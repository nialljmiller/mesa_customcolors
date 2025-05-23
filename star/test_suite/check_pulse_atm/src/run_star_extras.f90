! ***********************************************************************
!
!   Copyright (C) 2010  The MESA Team
!
!   This program is free software: you can redistribute it and/or modify
!   it under the terms of the GNU Lesser General Public License
!   as published by the Free Software Foundation,
!   either version 3 of the License, or (at your option) any later version.
!
!   This program is distributed in the hope that it will be useful,
!   but WITHOUT ANY WARRANTY; without even the implied warranty of
!   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
!   See the GNU Lesser General Public License for more details.
!
!   You should have received a copy of the GNU Lesser General Public License
!   along with this program. If not, see <https://www.gnu.org/licenses/>.
!
! ***********************************************************************

      module run_star_extras

      use star_lib
      use star_def
      use const_def
      use math_lib
      use auto_diff
      use utils_lib, only: mesa_error

      implicit none

      logical :: failed

      include 'test_suite_extras_def.inc'

      contains

      include 'test_suite_extras.inc'

      subroutine extras_controls(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         s% extras_startup => extras_startup
         s% extras_start_step => extras_start_step
         s% extras_check_model => extras_check_model
         s% extras_finish_step => extras_finish_step
         s% extras_after_evolve => extras_after_evolve
         s% how_many_extra_history_columns => how_many_extra_history_columns
         s% data_for_extra_history_columns => data_for_extra_history_columns
         s% how_many_extra_profile_columns => how_many_extra_profile_columns
         s% data_for_extra_profile_columns => data_for_extra_profile_columns
      end subroutine extras_controls


      subroutine extras_startup(id, restart, ierr)
         integer, intent(in) :: id
         logical, intent(in) :: restart
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call test_suite_startup(s, restart, ierr)

         failed = .false.

      end subroutine extras_startup


      subroutine extras_after_evolve(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         real(dp) :: dt
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call test_suite_after_evolve(s, ierr)

         if (.not. failed) write(*,*) 'all values are within tolerance'

      end subroutine extras_after_evolve


      integer function extras_start_step(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_start_step = 0
      end function extras_start_step


      ! returns either keep_going, retry, or terminate.
      integer function extras_check_model(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s

         integer :: i, k, n
         integer :: iounit, nz, iconst, ivar, ivers
         real(dp) :: Teff, T_check, T_face, T_rms, tau, row(5)
         real(dp), allocatable :: data(:,:)
         character(len=strlen) :: filename

         filename = 'check.fgong'

         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_check_model = keep_going

         ! every N models, save fgong and compare T to T(τ) relation

         if (MOD(s% model_number, 5) == 0) then
            ! save pulse data
            call star_export_pulse_data( &
                  id, 'FGONG', filename, &
                  s% add_center_point_to_pulse_data, &
                  s% keep_surface_point_for_pulse_data, &
                  s% add_atmosphere_to_pulse_data, &
                  ierr)
            if (ierr /= 0) then
               write(*,*) 'failed to save '//filename
               call mesa_error(__FILE__,__LINE__)
            end if

            ! load pulse data and compare it to reference value
            open(newunit=iounit, file=filename, status='OLD', iostat=ierr)
            if (ierr /= 0) then
               write(*,*) 'failed to open '//TRIM(filename)
               call mesa_error(__FILE__,__LINE__)
            end if

            ! skip header
            do k = 1, 4
               read(iounit, *, iostat=ierr)
            end do

            read(iounit, *, iostat=ierr) nz, iconst, ivar, ivers

            if ((iconst /= 15) .or. (ivar /= 40) .or. (ivers /= 1300)) then
               write(*,*) 'format of '//TRIM(filename)//' not as expected'
               call mesa_error(__FILE__,__LINE__)
            end if

            read(iounit, *, iostat=ierr) row  ! M, R, L, ...
            read(iounit, *, iostat=ierr) row  !
            read(iounit, *, iostat=ierr) row  ! ..., Teff, G

            Teff = row(4)

            allocate(data(ivar, nz))

            do k = 1, nz
               do i = 1, 40, 5
                  read(iounit, *, iostat=ierr) (data(n, k), n=i, i+4)
               end do
            end do

            close(iounit)

            ! initialise accumulators
            T_rms = 0.0_dp
            tau = s% atm_build_tau_outer
            n = 0

            do k = 1, nz-1
               T_check = Teff*pow(0.75_dp*(tau + q(s% atm_T_tau_relation, tau)), 0.25_dp)
               T_face = data(3,k)
               T_rms = T_rms + (T_face - T_check)**2
               n = n + 1

               ! Δτ = <ρ><κ>Δr
               tau = tau + 0.25_dp*(data(5,k)+data(5,k+1))*(data(8,k)+data(8,k+1))*(data(1,k)-data(1,k+1))

               if (tau > 0.1_dp) exit
            end do

            deallocate(data)

            T_rms = sqrt(T_rms/n)

            if (T_rms > s% x_ctrl(1)) then
               write(*,*) 'T_rms larger than target: ', trim(s% atm_T_tau_relation), T_rms, s% x_ctrl(1)
               failed = .true.
            end if

            ! cycle through T-tau relations
            select case(s% atm_T_tau_relation)
            case ('Eddington')
               s% atm_T_tau_relation = 'solar_Hopf'
            case ('solar_Hopf')
               s% atm_T_tau_relation = 'Krishna_Swamy'
            case ('Krishna_Swamy')
               s% atm_T_tau_relation = 'Trampedach_solar'
            case ('Trampedach_solar')
               s% atm_T_tau_relation = 'Eddington'
            case default
               write(*,*) 'Invalid atm_T_tau_relation: ', s% atm_T_tau_relation
               call mesa_error(__FILE__,__LINE__)
            end select

         end if

         ! cycle through opacity integration options
         if (MOD(s% model_number, 20) == 0) then
            select case(s% atm_T_tau_opacity)
            case ('fixed')
               s% atm_T_tau_opacity = 'iterated'
            case ('iterated')
               s% atm_T_tau_opacity = 'varying'
            case ('varying')
               s% atm_T_tau_opacity = 'fixed'
            case default
               write(*,*) 'Invalid atm_T_tau_opacity: ', s% atm_T_tau_opacity
               call mesa_error(__FILE__,__LINE__)
            end select
         end if

      end function extras_check_model


      integer function how_many_extra_history_columns(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_history_columns = 0
      end function how_many_extra_history_columns


      subroutine data_for_extra_history_columns(id, n, names, vals, ierr)
         integer, intent(in) :: id, n
         character (len=maxlen_history_column_name) :: names(n)
         real(dp) :: vals(n)
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
      end subroutine data_for_extra_history_columns


      integer function how_many_extra_profile_columns(id)
         use star_def, only: star_info
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_profile_columns = 1
      end function how_many_extra_profile_columns


      subroutine data_for_extra_profile_columns(id, n, nz, names, vals, ierr)
         use star_def, only: star_info, maxlen_profile_column_name
         use const_def, only: dp
         integer, intent(in) :: id, n, nz
         character (len=maxlen_profile_column_name) :: names(n)
         real(dp) :: vals(nz,n)
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         integer :: k
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return

         names(1) = 'T_check'
         do k = 1, s% nz
            vals(k,1) = s% Teff*pow(0.75_dp*(s% tau(k) + q(s% atm_T_tau_relation, s% tau(k))), 0.25_dp)
         end do

      end subroutine data_for_extra_profile_columns


      ! returns either keep_going or terminate.
      integer function extras_finish_step(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_finish_step = keep_going
      end function extras_finish_step


      real(dp) function q(name, tau)
         character(*), intent(in) :: name
         real(dp), intent(in) :: tau

         real(dp) :: x

         select case (name)
         case ('Eddington')
            q = two_thirds
         case ('solar_Hopf')
            q = 1.0361_dp - 0.3134_dp*exp(-2.44799995_dp*tau) &
                  - 0.29589999_dp*exp(-30.0_dp*tau)
         case ('Krishna_Swamy')
            q = 1.39_dp - 0.815_dp*exp(-2.54_dp*tau) &
                  - 0.025_dp*exp(-30.0_dp*tau)
         case ('Trampedach_solar')
            x = log10(tau)
            q = 0.6887302005929656_dp + 0.0668697860833449_dp*(x-0.1148742902769433_dp) &
                  + 0.7657856893402466_dp*exp((x-0.9262126497691250_dp)/0.7657856893402466_dp)
         case default
            write(*,*) 'Invalid name in q: ', name
            call mesa_error(__FILE__,__LINE__)
         end select

         return

      end function q

      end module run_star_extras

