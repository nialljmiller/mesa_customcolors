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

      module interp_1d_mp  ! high accuracy monotonicity preserving algorithms

      use const_def, only: dp

      implicit none
      private
      public :: m3, m3_on_uniform_grid

      contains


      subroutine m3(x, nx, f1, which, slope_only, nwork, work1, str, ierr)
         use interp_1d_def
         use interp_1d_misc
         use interp_1d_pm, only: mk_pmlinear, mk_pmquad
         integer, intent(in) :: nx       ! length of x vector
         real(dp), intent(in)    :: x(:)  ! (nx)    ! junction points, strictly monotonic
         real(dp), intent(inout), pointer :: f1(:)  ! =(4, nx)  ! data & interpolation coefficients
         integer, intent(in) :: which
         logical, intent(in) :: slope_only
         integer, intent(in) :: nwork
         real(dp), intent(inout), pointer :: work1(:)  ! =(nx, nwork)
         character (len=*) :: str
         integer, intent(out) :: ierr

         real(dp), dimension(:), pointer :: h, s_mid, s, d, d_mid, e_mid, hd_mid,  &
               spL, spR, t, tmax, tmp, tmp1, tmp2
         real(dp), parameter :: tiny = 1d-20
         integer :: i
         real(dp), pointer :: f(:,:)  ! (4, nx)  ! data & interpolation coefficients
         f(1:4,1:nx) => f1(1:4*nx)

         ierr = 0

         if (nx < 2) then
            return
         end if

         if (nx == 2) then
            call mk_pmlinear(x, f1, slope_only, nwork, work1, str, ierr)
            return
         end if

         if (nx == 3) then
            call mk_pmquad(x, f1, slope_only, nwork, work1, str, ierr)
            return
         end if

         if (nwork < mp_work_size) then
            ierr = -1
            return
         end if

         i = 0
         h(1:nx) => work1(i+1:i+nx); i = i+nx
         s_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         s(1:nx) => work1(i+1:i+nx); i = i+nx
         d(1:nx) => work1(i+1:i+nx); i = i+nx
         d_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         e_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         hd_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         spL(1:nx) => work1(i+1:i+nx); i = i+nx
         spR(1:nx) => work1(i+1:i+nx); i = i+nx
         t(1:nx) => work1(i+1:i+nx); i = i+nx
         tmax(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp1(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp2(1:nx) => work1(i+1:i+nx); i = i+nx

         ! grid spacing
         do i=1,nx-1
            h(i) = x(i+1) - x(i)
         end do
         do i = 1, nx-1
            if (h(i) == 0) then
               write(*, '(a,1x,2i5,1x,a)')  &
                  'same interpolation x values at', i, i+1, 'for ' // trim(str)
               ierr = -1
               return
            end if
         end do

         ! divided differences
         do i=1,nx-1
            s_mid(i) = (f(1,i+1) - f(1,i)) / h(i)  ! eqn 2.1
         end do
         do i=2,nx-1
            d(i) = (s_mid(i) - s_mid(i-1)) / (x(i+1) - x(i-1))  ! eqn 3.1
         end do
         ! need to extend d to full range. simplest way is just to copy from neighbor
         d(1) = d(2)
         d(nx) = d(nx-1)

         ! d_mid eqn(3.4) -- modified according to eqn (2.27) of Suresh & Huynh, 1997
         do i=1,nx-1
            tmp1(i) = 4*d(i+1) - d(i)
            tmp2(i) = 4*d(i) - d(i+1)
         end do
         call minmod4(d_mid(1:nx-1), nx-1, d(2:nx), d(1:nx-1), tmp1(1:nx-1), tmp2(1:nx-1))

         do i=1,nx-1
            hd_mid(i) = h(i)*d_mid(i)
         end do

         ! spL(i) = p'(i-1/2)(xi) = smid(i-1) + h(i-1)*d_mid(i-1) from Theorem 1
         do i=1,nx-1
            spL(i+1) = s_mid(i) + hd_mid(i)
         end do

         ! spR(i) = p'(i+1/2)(xi) = smid(i) - h(i)*d_mid(i) from Theorem 1
         do i=1,nx-1
            spR(i) = s_mid(i) - hd_mid(i)
         end do

         call minmod(s(2:nx-1), nx-2, s_mid(1:nx-2), s_mid(2:nx-1))  ! eqn (2.8)
         call minmod(t(2:nx-1), nx-2, spL(2:nx-1), spR(2:nx-1))

         if (which == average) then

            do i=2,nx-1
               f(2,i) = sign(1d0, t(i))* &
                  min((dabs(spL(i)+spR(i)))/2d0,  &
                     max(3*dabs(s(i)), 1.5d0*dabs(t(i))))
            end do

         else if (which == quartic) then

            do i=2,nx-2
               e_mid(i) = (d(i+1) - d(i)) / (x(i+2) - x(i-1))  ! eqn 4.1
            end do
            ! eqn 3.5b for p'(i); eqn 4.20 for quadratic f'(i)
            do i=3,nx-2
               f(2,i) = s_mid(i) -  &
                  h(i) * (d(i) + h(i-1)* &
                     (e_mid(i-1)*(x(i+2)-x(i))  &
                        + e_mid(i)*(x(i)-x(i-2)))/(x(i+2)-x(i-2)))
            end do
            ! finish off ends with average
            f(2,2) = sign(1d0, t(2))* &
                  min((dabs(spL(2)+spR(2)))/2d0, max(3*dabs(s(2)), 1.5d0*dabs(t(2))))
            f(2,nx-1) = sign(1d0, t(nx-1))* &
                  min((dabs(spL(nx-1)+spR(nx-1)))/2d0,  &
                  max(3*dabs(s(nx-1)), 1.5d0*dabs(t(nx-1))))
            do i=2,nx-1
               tmp1(i) = f(2,i)
               tmp2(i) = tmp1(i)
            end do
            call median(tmp1(2:nx-1), nx-2, tmp2(2:nx-1), spL(2:nx-1), spR(2:nx-1))
            do i=2,nx-1
               f(2,i) = tmp1(i)
            end do
            do i=2,nx-1
               tmax(i) = sign(1d0, t(i))* &
                  max(3*dabs(s(i)), 1.5d0*dabs(t(i)))
            end do
            do i=2,nx-1
               tmp1(i) = f(2,i)
            end do
            call minmod(tmp2(2:nx-1), nx-2, tmp1(2:nx-1), tmax(2:nx-1))
            do i=2,nx-1
               f(2,i) = tmp2(i)
            end do

         else  !if (which == super_bee) then

            do i=2,nx-1
               f(2,i) = sign(1d0, t(i))* &
                  min(max(dabs(spL(i)), dabs(spR(i))),  &
                     max(3*dabs(s(i)), 1.5d0*dabs(t(i))))
            end do

         end if

         ! slope at i=1
         !f(2, 1) = minmod1(spR(1), 3*s_mid(1)) ! eqn (5.2)
         f(2,1) = minmod1(s_mid(1), s_mid(2))  ! stabilize the ends

         ! slope at i=nx
         !f(2, nx) = minmod1(spL(nx), 3*s_mid(nx-1)) ! eqn (5.2)
         f(2,nx) = minmod1(s_mid(nx-2), s_mid(nx-1))  ! stabilize the ends

         if (slope_only) return

         ! 2nd and 3rd derivatives
         do i=1,nx-1
            f(3,i) = (3*s_mid(i) - 2*f(2,i) - f(2,i+1)) / h(i)
            f(4,i) = (f(2,i) + f(2,i+1) - 2*s_mid(i)) / (h(i)*h(i))
         end do
         f(3,nx) = (3*f(1, nx-1) - 3*f(1, nx) + (f(2, nx-1) + 2*f(2, nx)) * h(nx-1)) / (h(nx-1)*h(nx-1))
         f(4,nx) = (-2*f(1, nx-1) + 2*f(1, nx) - (f(2, nx-1) + f(2, nx))*h(nx-1)) / (h(nx-1)*h(nx-1)*h(nx-1))

      end subroutine m3


      subroutine m3_on_uniform_grid(dx, nx, f1, which, slope_only, nwork, work1, str, ierr)
         use interp_1d_def
         use interp_1d_misc
         use interp_1d_pm, only: mk_pmlinear, mk_pmquad
         ! make piecewise monotonic cubic interpolant
         real(dp), intent(in) :: dx  ! the grid spacing
         integer, intent(in) :: nx       ! length of x vector
         real(dp), intent(inout), pointer :: f1(:)  ! =(4, nx)  ! data & interpolation coefficients
         integer, intent(in) :: which
         logical, intent(in) :: slope_only
         integer, intent(in) :: nwork
         real(dp), intent(inout), pointer :: work1(:)  ! =(nx, nwork)
         character (len=*) :: str
         integer, intent(out) :: ierr

         real(dp), dimension(:), pointer :: s_mid, s, d, d_mid, e_mid, spL, spR, t, tmax,  &
            tmp, tmp1, tmp2
         real(dp), parameter :: tiny = 1d-20
         real(dp) :: x(3)
         integer :: i
         real(dp), pointer :: f(:,:)  ! (4, nx)  ! data & interpolation coefficients
         f(1:4,1:nx) => f1(1:4*nx)

         ierr = 0

         if (nx < 2) then
            return
         end if

         if (nx == 2) then
            x(1) = 0
            x(2) = dx
            call mk_pmlinear(x, f1, slope_only, nwork, work1, str, ierr)
            return
         end if

         if (nx == 3) then
            x(1) = 0
            x(2) = dx
            x(3) = 2*dx
            call mk_pmquad(x, f1, slope_only, nwork, work1, str, ierr)
            return
         end if

         if (dx == 0) then
            ierr = -1
            return
         end if

         if (nwork < mp_work_size) then
            ierr = -1
            return
         end if

         i = 0
         s_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         s(1:nx) => work1(i+1:i+nx); i = i+nx
         d(1:nx) => work1(i+1:i+nx); i = i+nx
         d_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         e_mid(1:nx) => work1(i+1:i+nx); i = i+nx
         spL(1:nx) => work1(i+1:i+nx); i = i+nx
         spR(1:nx) => work1(i+1:i+nx); i = i+nx
         t(1:nx) => work1(i+1:i+nx); i = i+nx
         tmax(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp1(1:nx) => work1(i+1:i+nx); i = i+nx
         tmp2(1:nx) => work1(i+1:i+nx); i = i+nx

         ! divided differences
         do i=1,nx-1
            s_mid(i) = (f(1,i+1) - f(1,i)) / dx  ! eqn 2.1
         end do
         do i=2,nx-1
            d(i) = (s_mid(i) - s_mid(i-1)) / (2*dx)  ! eqn 3.1
         end do
         ! need to extend d to full range. simplest way is just to copy from neighbor
         d(1) = d(2)
         d(nx) = d(nx-1)

         ! d_mid eqn(3.4) -- modified according to eqn (2.27) of Suresh & Huynh, 1997
         do i=1,nx-1
            tmp1(i) = 4*d(i+1) - d(i)
            tmp2(i) = 4*d(i) - d(i+1)
         end do
         call minmod4(d_mid(1:nx-1), nx-1, d(2:nx), d(1:nx-1), tmp1(1:nx-1), tmp2(1:nx-1))

         ! spL(i) = p'(i-1/2)(xi) = smid(i-1) + h(i-1)*d_mid(i-1) from Theorem 1
         do i=1,nx-1
            spL(i+1) = s_mid(i) + dx*d_mid(i)
         end do

         ! spR(i) = p'(i+1/2)(xi) = smid(i) - h(i)*d_mid(i) from Theorem 1
         do i=1,nx-1
            spR(i) = s_mid(i) - dx*d_mid(i)
         end do

         call minmod(s(2:nx-1), nx-2, s_mid(1:nx-2), s_mid(2:nx-1))  ! eqn (2.8)
         call minmod(t(2:nx-1), nx-2, spL(2:nx-1), spR(2:nx-1))

         if (which == average) then

            do i=2,nx-1
               f(2,i) = sign(1d0, t(i))* &
                  min((dabs(spL(i)+spR(i)))/2d0,  &
                     max(3*dabs(s(i)), 1.5d0*dabs(t(i))))
            end do

         else if (which == quartic) then

            do i=2,nx-2
               e_mid(i) = (d(i+1) - d(i)) / (3*dx)  ! eqn 4.1
            end do
            ! eqn 3.5b for p'(i); eqn 4.20 for quadratic f'(i)
            do i=3,nx-2
               f(2,i) = s_mid(i) -  &
                  dx * (d(i) + dx*(e_mid(i-1)*(2*dx) + e_mid(i)*(2*dx))/(4*dx))
            end do
            ! finish off ends with average
            f(2,2) = sign(1d0, t(2))* &
                  min((dabs(spL(2)+spR(2)))/2d0, max(3*dabs(s(2)), 1.5d0*dabs(t(2))))
            f(2,nx-1) = sign(1d0, t(nx-1))* &
                  min((dabs(spL(nx-1)+spR(nx-1)))/2d0,  &
                  max(3*dabs(s(nx-1)), 1.5d0*dabs(t(nx-1))))
            do i=2,nx-1
               tmp1(i) = f(2,i)
               tmp2(i) = tmp1(i)
            end do
            call median(tmp1(2:nx-1), nx-2, tmp2(2:nx-1), spL(2:nx-1), spR(2:nx-1))
            do i=2,nx-1
               f(2,i) = tmp1(i)
            end do
            do i=2,nx-1
               tmax(i) = sign(1d0, t(i))* &
                  max(3*dabs(s(i)), 1.5d0*dabs(t(i)))
            end do
            do i=2,nx-1
               tmp1(i) = f(2,i)
            end do
            call minmod(tmp2(2:nx-1), nx-2, tmp1(2:nx-1), tmax(2:nx-1))
            do i=2,nx-1
               f(2,i) = tmp2(i)
            end do

         else  !if (which == super_bee) then

            do i=2,nx-1
               f(2,i) = sign(1d0, t(i))* &
                  min(max(dabs(spL(i)), dabs(spR(i))),  &
                     max(3*dabs(s(i)), 1.5d0*dabs(t(i))))
            end do

         end if

         ! slope at i=1
         !f(2, 1) = minmod1(spR(1), 3*s_mid(1)) ! eqn (5.2)
         f(2,1) = minmod1(s_mid(1), s_mid(2))  ! stabilize the ends

         ! slope at i=nx
         !f(2, nx) = minmod1(spL(nx), 3*s_mid(nx-1)) ! eqn (5.2)
         f(2, nx) = minmod1(s_mid(nx-2), s_mid(nx-1))  ! stabilize the ends

         if (slope_only) return

         ! 2nd and 3rd derivatives
         do i=1,nx-1
            f(3,i) = (3*s_mid(i) - 2*f(2,i) - f(2,i+1)) / dx
            f(4,i) = (f(2,i) + f(2,i+1) - 2*s_mid(i)) / (dx*dx)
         end do
         f(3, nx) = (3*f(1, nx-1) - 3*f(1, nx) + (f(2, nx-1) + 2*f(2, nx)) * dx) / (dx*dx)
         f(4, nx) = (-2*f(1, nx-1) + 2*f(1, nx) - (f(2, nx-1) + f(2, nx))*dx) / (dx*dx*dx)

      end subroutine m3_on_uniform_grid


      end module interp_1d_mp
