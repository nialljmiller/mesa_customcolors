! star_data_step_input.inc
   ! input for taking a step.
   ! modified during the step so that at end holds the new model.
   ! can be saved in models and photos.

      real(dp) :: time ! elapsed time (seconds)
      real(dp) :: dt, dt_next ! timesteps (seconds)

      integer :: model_number, init_model_number
      integer :: nvar_hydro ! the number of structure variables per zone
      integer :: species ! species = number of isotopes in the current net
      integer :: nvar_chem ! the number of chemical abundance variables per zone
         ! = 0 for operator splitting with separate evolution of abundances
         ! = species to solve for all abundances solved coupled with structure
      integer :: nvar_total ! = nvar_hydro + nvar_chem
      integer :: nz ! the number of zones in the model

      ! inner boundary
      real(dp) :: M_center ! total baryonic mass (g) interior to innermost cell (usually 0)
      real(dp) :: v_center ! velocity (cm/s) of inner edge of innermost cell (usually 0)
      real(dp) :: R_center ! radius (cm) of inner edge of innermost cell (usually 0)
         ! R_center is automatically updated at each timestep if velocity_center is nonzero.
      real(dp) :: L_center ! luminosity (erg/s) at inner edge of innermost cell (usually 0)

      ! total baryonic mass (grams)
      real(dp) :: mstar
      real(dp) :: xmstar ! baryonic mass external to M_center
         ! thus mstar = M_center + xmstar

      ! dq(k) is the fraction of xmstar between points k and k+1
      real(dp), pointer, dimension(:) :: dq ! (nz)

      ! rotation
      real(dp), pointer, dimension(:) :: j_rot ! (nz)
        ! j_rot(k) is specific angular momentum at outer edge of cell k; = i_rot*omega
      real(dp), pointer, dimension(:) :: omega ! (nz)

      real(dp), pointer, dimension(:) :: D_ST_start ! For time smoothing
      real(dp), pointer, dimension(:) :: nu_ST_start
      logical :: have_ST_start_info

      ! convection
      real(dp), pointer, dimension(:) :: mlt_vc ! (nz)
      real(dp), pointer, dimension(:) :: conv_vel ! (nz)

      ! vectors of structure variables: xh(i,k) holds hydro structure variable i for point k.
         ! note: abundances are in xa, not in xh.  dq, j_rot, and omega are not in xh.
      real(dp), pointer, dimension(:,:) :: xh ! (nvar,nz)

      ! composition variables: xa(j,k) holds mass fraction of species j for location k
      ! j is an integer from 1 to s% species
      ! chem_id(j) gives the iso identifier from chem_def
      ! net_iso(chem_id(j)) = j
      real(dp), pointer, dimension(:,:) :: xa ! (species,nz)

      ! flags indicating extra variables and equations in addition to the minimal set
         logical :: v_flag ! true for velocity variables at cell boundaries
         logical :: u_flag ! true for velocity variables at cell centers
         logical :: rotation_flag ! true for rotation variables
         logical :: RTI_flag ! true for Rayleigh-Taylor instabilities
         logical :: RSP_flag ! true if we using RSP
         logical :: RSP2_flag ! true for turbulent velocity as a solver variable

      ! index definitions for the variables (= 0 if variable not in use)
         integer :: i_lnd ! ln(cell density average by mass)
         integer :: i_lnT ! ln cell temperature average by mass
         integer :: i_lnR ! ln radius at outer face of cell
         integer :: i_lum ! luminosity at outer face of cell
         integer :: i_v ! Lagrangian velocity at outer face of cell
         integer :: i_u ! Lagrangian velocity at center of cell
         integer :: i_alpha_RTI ! alpha for Rayleigh-Taylor instabilities
         integer :: i_Et_RSP, i_erad_RSP, i_Fr_RSP ! only when RSP_flag is true
         integer :: i_w ! cell turbulent velocity. only when RSP2_flag is true.
         integer :: i_Hp ! face pressure scale height. only when RSP2_flag is true.

      ! index definitions for the equations (= 0 if equation not in use)
         integer :: i_dlnR_dt ! dlnR/dt = v/r
         integer :: i_dv_dt ! momentum conservation using v
         integer :: i_du_dt ! momentum conservation using u
         integer :: i_dlnd_dt ! mass conservation
         integer :: i_dlnE_dt ! energy conservation
         integer :: i_equL ! luminosity
         integer :: i_dalpha_RTI_dt ! alpha for Rayleigh-Taylor instabilities
         integer :: i_dEt_RSP_dt, i_derad_RSP_dt, i_dFr_RSP_dt ! only when RSP_flag is true.
         integer :: i_detrb_dt ! turbulent energy equation. only when RSP2_flag is true.
         integer :: i_equ_Hp ! face pressure scale height equation. only when RSP2_flag is true.

      ! names of variables and equations
         character (len=name_len), dimension(:), pointer :: nameofvar, nameofequ ! (nvar)

      ! net_name identifies which net we are currently using
         character (len=net_name_len) :: net_name
      ! num_reactions = number of reactions in the current net
         integer :: num_reactions

      ! chem info
         integer, pointer :: chem_id(:) ! maps species to chem id
            ! index from 1 to species in current net
            ! value is between 1 and num_chem_isos
         integer, pointer :: net_iso(:) ! maps chem id to species number
            ! index from 1 to num_chem_isos
            ! value is 0 if the iso is not in the current net
            ! else is value between 1 and number of species in current net

      ! timestep information
         integer :: why_Tlim ! for the most recent timestep
         integer :: dt_why_retry_count(numTlim) ! counts incremented at each step with hard limit retry
         integer :: dt_why_count(numTlim) ! counts for non-hard limit steps

      ! counters
         integer :: total_step_attempts
         integer :: total_relax_step_attempts
         integer :: total_step_retries
         integer :: total_relax_step_retries
         integer :: total_step_redos
         integer :: total_relax_step_redos
         integer :: total_steps_finished
         integer :: total_relax_steps_finished

         integer :: num_skipped_setvars
         integer :: num_setvars
         integer :: num_solver_setvars

         integer :: num_hydro_merges
         integer :: num_hydro_splits

      ! past/future model numbers
         integer :: timestep_hold
         integer :: model_number_for_last_retry
         integer :: model_number_for_last_retry_old

      ! history
         integer, pointer :: profile_column_spec(:)
         integer :: number_of_history_columns
            ! number_of_history_columns = num_standard_history_columns + num extra history columns
         real(dp), pointer :: history_values(:) ! (number_of_history_columns)
         logical, pointer :: history_value_is_integer(:) ! (number_of_history_columns)
         character (len=maxlen_history_column_name), pointer :: &
            history_names(:) ! (number_of_history_columns)
         type (integer_dict), pointer :: history_names_dict
            ! maps names to index in history_values
         integer :: model_number_of_history_values
         logical :: need_to_set_history_names_etc
         ! the following does not include "extra" columns
         integer, pointer :: history_column_spec(:) ! (num_standard_history_columns)

      ! profile
         character (len=strlen) :: &
            model_profile_filename, model_controls_filename, model_data_filename
         character (len=strlen) :: &
            most_recent_profile_filename, most_recent_controls_filename, &
            most_recent_model_data_filename

      ! random number generator (marsaglia and zaman). period is 2**43 with
         ! 900 million different sequences. the state of the generator (for restarts)
         integer :: rand_i97, rand_j97
         real(dp) :: rand_u(rand_u_len), rand_c, rand_cd, rand_cm

      ! misc input information

         real(dp) :: Teff, dt_limit_ratio
         real(dp) :: cumulative_energy_error, cumulative_extra_heating
         real(dp) :: total_energy_initial, tau_factor, tau_base
         real(dp) :: force_tau_factor, force_Tsurf_factor, force_opacity_factor
         real(dp) :: revised_max_yr_dt, astero_revised_max_yr_dt
         real(dp) :: gradT_excess_alpha_old
         real(dp) :: crystal_core_boundary_mass

         logical :: include_binary_history_in_log_file
         logical :: using_revised_max_yr_dt, astero_using_revised_max_yr_dt
         logical :: have_initial_energy_integrals, have_j_rot
         logical :: D_omega_flag ! D_omega_flag is true if we are using D_omega for mixing
         logical :: am_nu_rot_flag ! smooth am_nu_rot like D_omega
         logical :: was_in_implicit_wind_limit
         logical :: rsp_have_set_velocities

         integer :: total_num_solver_iterations, total_num_solver_relax_iterations
         integer :: total_num_solver_calls_made, total_num_solver_relax_calls_made
         integer :: total_num_solver_calls_converged, total_num_solver_relax_calls_converged
         integer :: num_retries, phase_of_evolution
         integer :: recent_log_header ! model_number when last output header info to terminal
         integer :: mesh_call_number, solver_call_number, diffusion_call_number
         integer :: binary_id

         ! power emitted from nuclear reactions after subtracting neutrinos (Lsun units)
         ! these are used for timesteps, but are difficult to evaluate when doing op_split_burn until start solver.
         ! to get accurate "old" values, allow them as optional inputs.  don't use if < 0.
         real(dp) :: power_nuc_burn
         real(dp) :: power_h_burn
         real(dp) :: power_he_burn
         real(dp) :: power_z_burn
         real(dp) :: power_photo

      ! for read_model/write_model
         logical :: have_previous_conv_vel

      ! experimental work in progress.

         logical :: w_div_wc_flag ! true for w_div_wc as a solver variable
         logical :: j_rot_flag ! true for j_rot as a solver variable

         integer :: i_w_div_wc ! ratio of omega to critical value without the Eddington factor
         integer :: i_j_rot ! specific angular momentum associated to cell face

         integer :: i_equ_w_div_wc ! equation for w_div_wc
         integer :: i_dj_rot_dt ! equation for specific angular momentum


