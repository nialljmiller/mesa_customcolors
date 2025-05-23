! ***********************************************************************
!
!   Copyright (C) 2013  The MESA Team
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

      module pgstar_hist_track

      use star_private_def
      use const_def, only: dp
      use pgstar_support
      use star_pgstar

      implicit none

      contains

      subroutine History_Track1_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track1_plot(s, id, device_id, &
            s% pg% History_Track1_xleft, s% pg% History_Track1_xright, &
            s% pg% History_Track1_ybot, s% pg% History_Track1_ytop, .false., &
            s% pg% History_Track1_title, s% pg% History_Track1_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track1_plot


      subroutine do_History_Track1_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track1_xname, &
            s% pg% History_Track1_yname, &
            s% pg% History_Track1_xaxis_label, &
            s% pg% History_Track1_yaxis_label, &
            s% pg% History_Track1_xmin, &
            s% pg% History_Track1_xmax, &
            s% pg% History_Track1_xmargin, &
            s% pg% History_Track1_dxmin, &
            s% pg% History_Track1_ymin, &
            s% pg% History_Track1_ymax, &
            s% pg% History_Track1_ymargin, &
            s% pg% History_Track1_dymin, &
            s% pg% History_Track1_step_min, &
            s% pg% History_Track1_step_max, &
            s% pg% History_Track1_reverse_xaxis, &
            s% pg% History_Track1_reverse_yaxis, &
            s% pg% History_Track1_log_xaxis, &
            s% pg% History_Track1_log_yaxis, &
            s% pg% show_History_Track1_target_box, &
            s% pg% History_Track1_n_sigma, &
            s% pg% History_Track1_xtarget, &
            s% pg% History_Track1_ytarget, &
            s% pg% History_Track1_xsigma, &
            s% pg% History_Track1_ysigma, &
            s% pg% show_History_Track1_annotation1, &
            s% pg% show_History_Track1_annotation2, &
            s% pg% show_History_Track1_annotation3, &
            s% pg% History_Track1_fname, &
            s% pg% History_Track1_use_decorator, &
            s% pg% History_Track1_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track1_plot


      subroutine History_Track2_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track2_plot(s, id, device_id, &
            s% pg% History_Track2_xleft, s% pg% History_Track2_xright, &
            s% pg% History_Track2_ybot, s% pg% History_Track2_ytop, .false., &
            s% pg% History_Track2_title, s% pg% History_Track2_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track2_plot


      subroutine do_History_Track2_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track2_xname, &
            s% pg% History_Track2_yname, &
            s% pg% History_Track2_xaxis_label, &
            s% pg% History_Track2_yaxis_label, &
            s% pg% History_Track2_xmin, &
            s% pg% History_Track2_xmax, &
            s% pg% History_Track2_xmargin, &
            s% pg% History_Track2_dxmin, &
            s% pg% History_Track2_ymin, &
            s% pg% History_Track2_ymax, &
            s% pg% History_Track2_ymargin, &
            s% pg% History_Track2_dymin, &
            s% pg% History_Track2_step_min, &
            s% pg% History_Track2_step_max, &
            s% pg% History_Track2_reverse_xaxis, &
            s% pg% History_Track2_reverse_yaxis, &
            s% pg% History_Track2_log_xaxis, &
            s% pg% History_Track2_log_yaxis, &
            s% pg% show_History_Track2_target_box, &
            s% pg% History_Track2_n_sigma, &
            s% pg% History_Track2_xtarget, &
            s% pg% History_Track2_ytarget, &
            s% pg% History_Track2_xsigma, &
            s% pg% History_Track2_ysigma, &
            s% pg% show_History_Track2_annotation1, &
            s% pg% show_History_Track2_annotation2, &
            s% pg% show_History_Track2_annotation3, &
            s% pg% History_Track2_fname, &
            s% pg% History_Track2_use_decorator, &
            s% pg% History_Track2_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track2_plot


      subroutine History_Track3_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track3_plot(s, id, device_id, &
            s% pg% History_Track3_xleft, s% pg% History_Track3_xright, &
            s% pg% History_Track3_ybot, s% pg% History_Track3_ytop, .false., &
            s% pg% History_Track3_title, s% pg% History_Track3_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track3_plot


      subroutine do_History_Track3_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track3_xname, &
            s% pg% History_Track3_yname, &
            s% pg% History_Track3_xaxis_label, &
            s% pg% History_Track3_yaxis_label, &
            s% pg% History_Track3_xmin, &
            s% pg% History_Track3_xmax, &
            s% pg% History_Track3_xmargin, &
            s% pg% History_Track3_dxmin, &
            s% pg% History_Track3_ymin, &
            s% pg% History_Track3_ymax, &
            s% pg% History_Track3_ymargin, &
            s% pg% History_Track3_dymin, &
            s% pg% History_Track3_step_min, &
            s% pg% History_Track3_step_max, &
            s% pg% History_Track3_reverse_xaxis, &
            s% pg% History_Track3_reverse_yaxis, &
            s% pg% History_Track3_log_xaxis, &
            s% pg% History_Track3_log_yaxis, &
            s% pg% show_History_Track3_target_box, &
            s% pg% History_Track3_n_sigma, &
            s% pg% History_Track3_xtarget, &
            s% pg% History_Track3_ytarget, &
            s% pg% History_Track3_xsigma, &
            s% pg% History_Track3_ysigma, &
            s% pg% show_History_Track3_annotation1, &
            s% pg% show_History_Track3_annotation2, &
            s% pg% show_History_Track3_annotation3, &
            s% pg% History_Track3_fname, &
            s% pg% History_Track3_use_decorator, &
            s% pg% History_Track3_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track3_plot


      subroutine History_Track4_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track4_plot(s, id, device_id, &
            s% pg% History_Track4_xleft, s% pg% History_Track4_xright, &
            s% pg% History_Track4_ybot, s% pg% History_Track4_ytop, .false., &
            s% pg% History_Track4_title, s% pg% History_Track4_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track4_plot


      subroutine do_History_Track4_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track4_xname, &
            s% pg% History_Track4_yname, &
            s% pg% History_Track4_xaxis_label, &
            s% pg% History_Track4_yaxis_label, &
            s% pg% History_Track4_xmin, &
            s% pg% History_Track4_xmax, &
            s% pg% History_Track4_xmargin, &
            s% pg% History_Track4_dxmin, &
            s% pg% History_Track4_ymin, &
            s% pg% History_Track4_ymax, &
            s% pg% History_Track4_ymargin, &
            s% pg% History_Track4_dymin, &
            s% pg% History_Track4_step_min, &
            s% pg% History_Track4_step_max, &
            s% pg% History_Track4_reverse_xaxis, &
            s% pg% History_Track4_reverse_yaxis, &
            s% pg% History_Track4_log_xaxis, &
            s% pg% History_Track4_log_yaxis, &
            s% pg% show_History_Track4_target_box, &
            s% pg% History_Track4_n_sigma, &
            s% pg% History_Track4_xtarget, &
            s% pg% History_Track4_ytarget, &
            s% pg% History_Track4_xsigma, &
            s% pg% History_Track4_ysigma, &
            s% pg% show_History_Track4_annotation1, &
            s% pg% show_History_Track4_annotation2, &
            s% pg% show_History_Track4_annotation3, &
            s% pg% History_Track4_fname, &
            s% pg% History_Track4_use_decorator, &
            s% pg% History_Track4_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track4_plot


      subroutine History_Track5_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track5_plot(s, id, device_id, &
            s% pg% History_Track5_xleft, s% pg% History_Track5_xright, &
            s% pg% History_Track5_ybot, s% pg% History_Track5_ytop, .false., &
            s% pg% History_Track5_title, s% pg% History_Track5_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track5_plot


      subroutine do_History_Track5_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track5_xname, &
            s% pg% History_Track5_yname, &
            s% pg% History_Track5_xaxis_label, &
            s% pg% History_Track5_yaxis_label, &
            s% pg% History_Track5_xmin, &
            s% pg% History_Track5_xmax, &
            s% pg% History_Track5_xmargin, &
            s% pg% History_Track5_dxmin, &
            s% pg% History_Track5_ymin, &
            s% pg% History_Track5_ymax, &
            s% pg% History_Track5_ymargin, &
            s% pg% History_Track5_dymin, &
            s% pg% History_Track5_step_min, &
            s% pg% History_Track5_step_max, &
            s% pg% History_Track5_reverse_xaxis, &
            s% pg% History_Track5_reverse_yaxis, &
            s% pg% History_Track5_log_xaxis, &
            s% pg% History_Track5_log_yaxis, &
            s% pg% show_History_Track5_target_box, &
            s% pg% History_Track5_n_sigma, &
            s% pg% History_Track5_xtarget, &
            s% pg% History_Track5_ytarget, &
            s% pg% History_Track5_xsigma, &
            s% pg% History_Track5_ysigma, &
            s% pg% show_History_Track5_annotation1, &
            s% pg% show_History_Track5_annotation2, &
            s% pg% show_History_Track5_annotation3, &
            s% pg% History_Track5_fname, &
            s% pg% History_Track5_use_decorator, &
            s% pg% History_Track5_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track5_plot


      subroutine History_Track6_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track6_plot(s, id, device_id, &
            s% pg% History_Track6_xleft, s% pg% History_Track6_xright, &
            s% pg% History_Track6_ybot, s% pg% History_Track6_ytop, .false., &
            s% pg% History_Track6_title, s% pg% History_Track6_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track6_plot


      subroutine do_History_Track6_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track6_xname, &
            s% pg% History_Track6_yname, &
            s% pg% History_Track6_xaxis_label, &
            s% pg% History_Track6_yaxis_label, &
            s% pg% History_Track6_xmin, &
            s% pg% History_Track6_xmax, &
            s% pg% History_Track6_xmargin, &
            s% pg% History_Track6_dxmin, &
            s% pg% History_Track6_ymin, &
            s% pg% History_Track6_ymax, &
            s% pg% History_Track6_ymargin, &
            s% pg% History_Track6_dymin, &
            s% pg% History_Track6_step_min, &
            s% pg% History_Track6_step_max, &
            s% pg% History_Track6_reverse_xaxis, &
            s% pg% History_Track6_reverse_yaxis, &
            s% pg% History_Track6_log_xaxis, &
            s% pg% History_Track6_log_yaxis, &
            s% pg% show_History_Track6_target_box, &
            s% pg% History_Track6_n_sigma, &
            s% pg% History_Track6_xtarget, &
            s% pg% History_Track6_ytarget, &
            s% pg% History_Track6_xsigma, &
            s% pg% History_Track6_ysigma, &
            s% pg% show_History_Track6_annotation1, &
            s% pg% show_History_Track6_annotation2, &
            s% pg% show_History_Track6_annotation3, &
            s% pg% History_Track6_fname, &
            s% pg% History_Track6_use_decorator, &
            s% pg% History_Track6_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track6_plot


      subroutine History_Track7_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track7_plot(s, id, device_id, &
            s% pg% History_Track7_xleft, s% pg% History_Track7_xright, &
            s% pg% History_Track7_ybot, s% pg% History_Track7_ytop, .false., &
            s% pg% History_Track7_title, s% pg% History_Track7_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track7_plot


      subroutine do_History_Track7_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track7_xname, &
            s% pg% History_Track7_yname, &
            s% pg% History_Track7_xaxis_label, &
            s% pg% History_Track7_yaxis_label, &
            s% pg% History_Track7_xmin, &
            s% pg% History_Track7_xmax, &
            s% pg% History_Track7_xmargin, &
            s% pg% History_Track7_dxmin, &
            s% pg% History_Track7_ymin, &
            s% pg% History_Track7_ymax, &
            s% pg% History_Track7_ymargin, &
            s% pg% History_Track7_dymin, &
            s% pg% History_Track7_step_min, &
            s% pg% History_Track7_step_max, &
            s% pg% History_Track7_reverse_xaxis, &
            s% pg% History_Track7_reverse_yaxis, &
            s% pg% History_Track7_log_xaxis, &
            s% pg% History_Track7_log_yaxis, &
            s% pg% show_History_Track7_target_box, &
            s% pg% History_Track7_n_sigma, &
            s% pg% History_Track7_xtarget, &
            s% pg% History_Track7_ytarget, &
            s% pg% History_Track7_xsigma, &
            s% pg% History_Track7_ysigma, &
            s% pg% show_History_Track7_annotation1, &
            s% pg% show_History_Track7_annotation2, &
            s% pg% show_History_Track7_annotation3, &
            s% pg% History_Track7_fname, &
            s% pg% History_Track7_use_decorator, &
            s% pg% History_Track7_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track7_plot


      subroutine History_Track8_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track8_plot(s, id, device_id, &
            s% pg% History_Track8_xleft, s% pg% History_Track8_xright, &
            s% pg% History_Track8_ybot, s% pg% History_Track8_ytop, .false., &
            s% pg% History_Track8_title, s% pg% History_Track8_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track8_plot


      subroutine do_History_Track8_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track8_xname, &
            s% pg% History_Track8_yname, &
            s% pg% History_Track8_xaxis_label, &
            s% pg% History_Track8_yaxis_label, &
            s% pg% History_Track8_xmin, &
            s% pg% History_Track8_xmax, &
            s% pg% History_Track8_xmargin, &
            s% pg% History_Track8_dxmin, &
            s% pg% History_Track8_ymin, &
            s% pg% History_Track8_ymax, &
            s% pg% History_Track8_ymargin, &
            s% pg% History_Track8_dymin, &
            s% pg% History_Track8_step_min, &
            s% pg% History_Track8_step_max, &
            s% pg% History_Track8_reverse_xaxis, &
            s% pg% History_Track8_reverse_yaxis, &
            s% pg% History_Track8_log_xaxis, &
            s% pg% History_Track8_log_yaxis, &
            s% pg% show_History_Track8_target_box, &
            s% pg% History_Track8_n_sigma, &
            s% pg% History_Track8_xtarget, &
            s% pg% History_Track8_ytarget, &
            s% pg% History_Track8_xsigma, &
            s% pg% History_Track8_ysigma, &
            s% pg% show_History_Track8_annotation1, &
            s% pg% show_History_Track8_annotation2, &
            s% pg% show_History_Track8_annotation3, &
            s% pg% History_Track8_fname, &
            s% pg% History_Track8_use_decorator, &
            s% pg% History_Track8_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track8_plot


      subroutine History_Track9_plot(id, device_id, ierr)
         integer, intent(in) :: id, device_id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return
         call pgslct(device_id)
         call pgbbuf()
         call pgeras()
         call do_History_Track9_plot(s, id, device_id, &
            s% pg% History_Track9_xleft, s% pg% History_Track9_xright, &
            s% pg% History_Track9_ybot, s% pg% History_Track9_ytop, .false., &
            s% pg% History_Track9_title, s% pg% History_Track9_txt_scale, ierr)
         if (ierr /= 0) return
         call pgebuf()
      end subroutine History_Track9_plot


      subroutine do_History_Track9_plot(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, device_id
         real, intent(in) :: vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale
         logical, intent(in) :: subplot
         character (len=*), intent(in) :: title
         integer, intent(out) :: ierr
         call do_Hist_Track(s, id,device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            s% pg% History_Track9_xname, &
            s% pg% History_Track9_yname, &
            s% pg% History_Track9_xaxis_label, &
            s% pg% History_Track9_yaxis_label, &
            s% pg% History_Track9_xmin, &
            s% pg% History_Track9_xmax, &
            s% pg% History_Track9_xmargin, &
            s% pg% History_Track9_dxmin, &
            s% pg% History_Track9_ymin, &
            s% pg% History_Track9_ymax, &
            s% pg% History_Track9_ymargin, &
            s% pg% History_Track9_dymin, &
            s% pg% History_Track9_step_min, &
            s% pg% History_Track9_step_max, &
            s% pg% History_Track9_reverse_xaxis, &
            s% pg% History_Track9_reverse_yaxis, &
            s% pg% History_Track9_log_xaxis, &
            s% pg% History_Track9_log_yaxis, &
            s% pg% show_History_Track9_target_box, &
            s% pg% History_Track9_n_sigma, &
            s% pg% History_Track9_xtarget, &
            s% pg% History_Track9_ytarget, &
            s% pg% History_Track9_xsigma, &
            s% pg% History_Track9_ysigma, &
            s% pg% show_History_Track9_annotation1, &
            s% pg% show_History_Track9_annotation2, &
            s% pg% show_History_Track9_annotation3, &
            s% pg% History_Track9_fname, &
            s% pg% History_Track9_use_decorator, &
            s% pg% History_Track9_pgstar_decorator, &
            null_decorate, ierr)
      end subroutine do_History_Track9_plot


      subroutine null_decorate(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         ierr = 0
      end subroutine null_decorate


      subroutine do_Hist_Track(s, id, device_id, &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, subplot, title, txt_scale, &
            xname, yname, xaxis_label, yaxis_label, &
            given_xmin, given_xmax, xmargin, dxmin, &
            given_ymin, given_ymax, ymargin, dymin, &
            step_min_in, step_max_in, &
            reverse_xaxis, reverse_yaxis, &
            log_xaxis, log_yaxis, &
            show_target_box, n_sigma, &
            xtarget, ytarget, xsigma, ysigma, &
            show_annotation1, show_annotation2, show_annotation3, &
            fname, &
            use_decorator, pgstar_decorator, &
            decorate, ierr)
         use utils_lib
         use pgstar_colors

         type (star_info), pointer :: s
         integer, intent(in) :: &
            id, device_id, step_min_in, step_max_in, n_sigma
         real, intent(in) :: &
            vp_xleft, vp_xright, vp_ybot, vp_ytop, txt_scale, &
            xtarget, ytarget, xsigma, ysigma, &
            given_xmin, given_xmax, xmargin, dxmin, &
            given_ymin, given_ymax, ymargin, dymin
         character (len=*), intent(in) :: &
            title, xname, yname, xaxis_label, yaxis_label, fname
         logical, intent(in) :: subplot, &
            reverse_xaxis, reverse_yaxis, log_xaxis, log_yaxis, show_target_box, &
            show_annotation1, show_annotation2, show_annotation3, use_decorator
         interface
            subroutine decorate(id, ierr)
               implicit none
               integer, intent(in) :: id
               integer, intent(out) :: ierr
            end subroutine decorate
         end interface
         integer, intent(out) :: ierr
         procedure(pgstar_decorator_interface), pointer :: pgstar_decorator

         real :: xleft, xright, ybot, ytop
         integer :: j, j_min, j_max, step_min, step_max
         real :: dx, dy, xplus, xminus, yplus, yminus
         real, dimension(:), allocatable :: xvec, yvec
         integer :: k, n
         integer :: ix, iy
         integer :: file_data_len
         real, allocatable, dimension(:) :: file_data_xvec, file_data_yvec

         logical, parameter :: dbg = .false.

         include 'formats'

         ierr = 0

         call integer_dict_lookup(s% history_names_dict, xname, ix, ierr)
         if (ierr /= 0) ix = -1
         if (ix <= 0) then
            write(*,'(A)')
            write(*,*) 'ERROR: failed to find ' // &
               trim(xname) // ' in history data'
            write(*,'(A)')
            ierr = -1
         end if

         call integer_dict_lookup(s% history_names_dict, yname, iy, ierr)
         if (ierr /= 0) iy = -1
         if (iy <= 0) then
            write(*,'(A)')
            write(*,*) 'ERROR: failed to find ' // &
               trim(yname) // ' in history data'
            write(*,'(A)')
            ierr = -1
         end if
         if (ierr /= 0) return
         step_min = max(step_min_in, 1)
         if (step_max_in >= 0) then
            step_max = min(step_max_in, s% model_number)
         else
            step_max = s% model_number
         end if
         n = count_hist_points(s, step_min, step_max)
         allocate(xvec(n), yvec(n), stat=ierr)
         if (ierr /= 0) then
            write(*,*) 'allocate failed for PGSTAR'
            return
         end if

         call get_hist_points(s, step_min, step_max, n, ix, xvec, ierr)
         if (ierr /= 0) then
            write(*,*) 'pgstar do_Hist_Track get_hist_points failed ' // trim(xname)
            ierr = 0
            !return
         end if
         call get_hist_points(s, step_min, step_max, n, iy, yvec, ierr)
         if (ierr /= 0) then
            write(*,*) 'pgstar do_Hist_Track get_hist_points failed ' // trim(yname)
            ierr = 0
            !return
         end if

         if (log_xaxis) then
            do k=1,n
               xvec(k) = log10(max(tiny(xvec(k)),abs(xvec(k))))
            end do
         end if

         if (log_yaxis) then
            do k=1,n
               yvec(k) = log10(max(tiny(yvec(k)),abs(yvec(k))))
            end do
         end if

         call set_xleft_xright( &
            n, xvec, given_xmin, given_xmax, xmargin, &
            reverse_xaxis, dxmin, xleft, xright)

         call set_ytop_ybot( &
            n, yvec, given_ymin, given_ymax, -101.0, ymargin, &
            reverse_yaxis, dymin, ybot, ytop)

         call pgsave
         call pgsch(txt_scale)
         call pgsvp(vp_xleft, vp_xright, vp_ybot, vp_ytop)
         call pgswin(xleft, xright, ybot, ytop)
         call pgscf(1)
         call pgsci(clr_Foreground)
         call show_box_pgstar(s,'BCNST1','BCNSTV1')

         if (log_xaxis) then
            call show_xaxis_label_pgstar(s,'log ' // xaxis_label)
         else
            call show_xaxis_label_pgstar(s,xaxis_label)
         end if

         if (log_yaxis) then
            call show_left_yaxis_label_pgstar(s,'log ' // yaxis_label)
         else
            call show_left_yaxis_label_pgstar(s,yaxis_label)
         end if

         if (.not. subplot) then
            call show_model_number_pgstar(s)
            call show_age_pgstar(s)
         end if
         call show_title_pgstar(s, title)

         call pgslw(s% pg% pgstar_lw)

         call show_file_track

         if (show_target_box) then
            call pgsci(clr_Silver)
            if (n_sigma >= 0) then
               j_min = n_sigma
               j_max = n_sigma
            else
               j_min = 1
               j_max = -n_sigma
            end if
            do j=j_min, j_max
               dx = xsigma*j
               xplus = xtarget + dx
               xminus = xtarget - dx
               if (log_xaxis) then
                  xplus = log10(max(tiny(xplus),xplus))
                  xminus = log10(max(tiny(xminus),xminus))
               end if
               dy = ysigma*j
               yplus = ytarget + dy
               yminus = ytarget - dy
               if (log_yaxis) then
                  yplus = log10(max(tiny(yplus),yplus))
                  yminus = log10(max(tiny(yminus),yminus))
               end if
               call pgmove(xminus, yminus)
               call pgdraw(xplus, yminus)
               call pgdraw(xplus, yplus)
               call pgdraw(xminus, yplus)
               call pgdraw(xminus, yminus)
            end do
         end if

         call pgsci(clr_Teal)
         call pgline(n, xvec, yvec)
         call pgsci(clr_Crimson)
         call pgsch(2.8*txt_scale)
         call pgpt1(xvec(n), yvec(n), 0902)

         call show_annotations(s, &
            show_annotation1, &
            show_annotation2, &
            show_annotation3)

         call decorate(s% id, ierr)

         call pgunsa

         call show_pgstar_decorator(s%id, use_decorator, pgstar_decorator, 0, ierr)

         deallocate(xvec, yvec)

         contains


         subroutine show_file_track
            use pgstar_colors
            integer :: k
            if (len_trim(fname) == 0) return
            if (.not. read_values_from_file(fname, &
                  file_data_xvec, file_data_yvec, file_data_len)) then
               write(*,*) &
                  'bad filename for History tracks plot ' // trim(fname)
               return
            end if
            if (log_xaxis) then
               do k=1,file_data_len
                  file_data_xvec(k) = log10(max(tiny(file_data_xvec(k)),abs(file_data_xvec(k))))
               end do
            end if
            if (log_yaxis) then
               do k=1,file_data_len
                  file_data_yvec(k) = log10(max(tiny(file_data_yvec(k)),abs(file_data_yvec(k))))
               end do
            end if
            call pgsci(clr_Goldenrod)
            call pgline(file_data_len, file_data_xvec, file_data_yvec)
            deallocate(file_data_xvec, file_data_yvec)
         end subroutine show_file_track


      end subroutine do_Hist_Track

      end module pgstar_hist_track
