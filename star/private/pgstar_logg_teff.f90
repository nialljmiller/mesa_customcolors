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

      module pgstar_logg_Teff

      use star_private_def
      use const_def, only: dp
      use pgstar_support
      use star_pgstar

      implicit none

      contains

      subroutine logg_Teff_Plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr

         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return

         call pgslct(device_id)
         call pgbbuf()
         call pgeras()

         call do_logg_Teff_Plot(s, id, device_id, &
            s% pg% logg_Teff_xleft, s% pg% logg_Teff_xright, &
            s% pg% logg_Teff_ybot, s% pg% logg_Teff_ytop, .false., &
            s% pg% logg_Teff_title, s% pg% logg_Teff_txt_scale, ierr)
         if (ierr /= 0) return

         call pgebuf()

      end subroutine logg_Teff_Plot


      subroutine do_logg_Teff_Plot(s, id, device_id, &
            xleft, xright, ybot, ytop, subplot, &
            title, txt_scale, ierr)
         use pgstar_hist_track, only: null_decorate, do_Hist_Track
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: xleft, xright, ybot, ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         logical, parameter :: &
            reverse_xaxis = .true., reverse_yaxis = .true.
         ierr = 0
         call do_Hist_Track(s, id, device_id, &
            xleft, xright, ybot, ytop, subplot, title, txt_scale, &
            'effective_T', 'log_g', &
            'Teff', 'log g', &
            s% pg% logg_Teff_Teff_min, s% pg% logg_Teff_Teff_max, &
            s% pg% logg_Teff_Teff_margin, s% pg% logg_Teff_dTeff_min, &
            s% pg% logg_Teff_logg_min, s% pg% logg_Teff_logg_max, &
            s% pg% logg_Teff_logg_margin, s% pg% logg_Teff_dlogg_min, &
            s% pg% logg_Teff_step_min, s% pg% logg_Teff_step_max, &
            reverse_xaxis, reverse_yaxis, .false., .false., &
            s% pg% show_logg_Teff_target_box, s% pg% logg_Teff_target_n_sigma, &
            s% pg% logg_Teff_target_Teff, s% pg% logg_Teff_target_logg, &
            s% pg% logg_Teff_target_Teff_sigma, s% pg% logg_Teff_target_logg_sigma, &
            s% pg% show_logg_Teff_annotation1, &
            s% pg% show_logg_Teff_annotation2, &
            s% pg% show_logg_Teff_annotation3, &
            s% pg% logg_Teff_fname, &
            s% pg% logg_Teff_use_decorator, &
            s% pg% logg_Teff_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_logg_Teff_Plot

      end module pgstar_logg_Teff
