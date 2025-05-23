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

      implicit none

      include "test_suite_extras_def.inc"

      contains

      include "test_suite_extras.inc"


      subroutine extras_controls(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return

         s% extras_startup => extras_startup
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
      end subroutine extras_startup


      subroutine extras_after_evolve(id, ierr)
         use num_lib
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         real(dp) :: dt
         integer :: k, k_cntr, k_surf

         logical :: okay
         type (star_info), pointer :: s
         character (len=strlen) :: test
         include 'formats'
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         okay = .true.

         call test_suite_after_evolve(s, ierr)
         write(*,'(A)')
         call check('log total_angular_momentum', safe_log10(s% total_angular_momentum), 45d0, 55d0)
         call check('log center_omega', safe_log10(s% center_omega), -4d0, -2d0)
         call check('log he_core_omega', safe_log10(s% he_core_omega), -6d0, -3d0)
         call check('surface j_rot', safe_log10(s% j_rot(1)),  5d0, 25d0)
         call check('surface v_rot', s% omega(1)*s% r(1)*1d-5, 0d0, 1d0)

         k_cntr = 0
         k_surf = 0
         do k = s% nz, 1, -1
            if (s% m(k) > 0.24d0*Msun .and. k_cntr == 0) k_cntr = k
            if (s% m(k) > 0.25d0*Msun .and. k_surf == 0) k_surf = k
         end do

         if (k_surf >=1 .and. k_cntr <= s% nz) then
            write(*,'(A)')
            write(*,1) 'avg near 0.245 Msun'
            call check('logT', avg_val(s% lnT)/ln10, 7d0, 7.5d0)
            call check('logRho', avg_val(s% lnd)/ln10, 0.5d0, 2.0d0)
            call check('log j_rot', safe_log10(avg_val(s% j_rot)), 10d0, 20d0)
            call check('D_ST', safe_log10(avg_val(s% D_ST)), 1d0, 8d0)
            call check('nu_ST', safe_log10(avg_val(s% nu_ST)), 4.0d0, 9.0d0)
            !call check('dynamo_B_r', safe_log10(avg_val(s% dynamo_B_r)), 0d0, 2d0)
            !call check('dynamo_B_phi', safe_log10(avg_val(s% dynamo_B_phi)), 3d0, 7d0)
            write(*,'(A)')
            if (okay) write(*,'(a)') 'all values are within tolerances'
            end if
         write(*,'(A)')


         contains

         real(dp) function avg_val(v)
            real(dp) :: v(:)
            avg_val = dot_product(v(k_surf:k_cntr), s% dq(k_surf:k_cntr)) / sum(s% dq(k_surf:k_cntr))
         end function avg_val

         subroutine check(str, val, low, hi)
            real(dp), intent(in) :: val, low, hi
            character (len=*) :: str
            include 'formats'
            if (low <= val .and. val <= hi) then
               write(*,1) trim(str), val, low, hi
            else
               write(*,1) '*** BAD *** ' // trim(str), val, low, hi
               okay = .false.
            end if
         end subroutine check


      end subroutine extras_after_evolve


      ! returns either keep_going, retry, or terminate.
      integer function extras_check_model(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         include 'formats'

         extras_check_model = keep_going

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
         how_many_extra_profile_columns = 0
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


      end module run_star_extras

