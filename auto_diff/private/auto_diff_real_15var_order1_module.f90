! ***********************************************************************
!
!   Copyright (C) 2022  The MESA Team
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

module auto_diff_real_15var_order1_module
      use const_def, only: dp, ln10
      use utils_lib
      use support_functions
      use math_lib

      implicit none
      private
   public :: auto_diff_real_15var_order1, &
      assignment(=), &
      operator(.eq.), &
      operator(.ne.), &
      operator(.gt.), &
      operator(.lt.), &
      operator(.le.), &
      operator(.ge.), &
      make_unop, &
      make_binop, &
      operator(-), &
      exp, &
      log, &
      safe_log, &
      log10, &
      safe_log10, &
      sin, &
      cos, &
      tan, &
      sinh, &
      cosh, &
      tanh, &
      asin, &
      acos, &
      atan, &
      asinh, &
      acosh, &
      atanh, &
      sqrt, &
      pow2, &
      pow3, &
      pow4, &
      pow5, &
      pow6, &
      pow7, &
      abs, &
      operator(+), &
      operator(*), &
      operator(/), &
      operator(**), &
      max, &
      min, &
      dim, &
      pow
   type :: auto_diff_real_15var_order1
      real(dp) :: val
      real(dp) :: d1Array(15)
   end type auto_diff_real_15var_order1

   interface assignment(=)
      module procedure assign_from_self
      module procedure assign_from_real_dp
      module procedure assign_from_int
   end interface assignment(=)

   interface operator(.eq.)
      module procedure equal_self
      module procedure equal_auto_diff_real_15var_order1_real_dp
      module procedure equal_real_dp_auto_diff_real_15var_order1
      module procedure equal_auto_diff_real_15var_order1_int
      module procedure equal_int_auto_diff_real_15var_order1
   end interface operator(.eq.)

   interface operator(.ne.)
      module procedure neq_self
      module procedure neq_auto_diff_real_15var_order1_real_dp
      module procedure neq_real_dp_auto_diff_real_15var_order1
      module procedure neq_auto_diff_real_15var_order1_int
      module procedure neq_int_auto_diff_real_15var_order1
   end interface operator(.ne.)

   interface operator(.gt.)
      module procedure greater_self
      module procedure greater_auto_diff_real_15var_order1_real_dp
      module procedure greater_real_dp_auto_diff_real_15var_order1
      module procedure greater_auto_diff_real_15var_order1_int
      module procedure greater_int_auto_diff_real_15var_order1
   end interface operator(.gt.)

   interface operator(.lt.)
      module procedure less_self
      module procedure less_auto_diff_real_15var_order1_real_dp
      module procedure less_real_dp_auto_diff_real_15var_order1
      module procedure less_auto_diff_real_15var_order1_int
      module procedure less_int_auto_diff_real_15var_order1
   end interface operator(.lt.)

   interface operator(.le.)
      module procedure leq_self
      module procedure leq_auto_diff_real_15var_order1_real_dp
      module procedure leq_real_dp_auto_diff_real_15var_order1
      module procedure leq_auto_diff_real_15var_order1_int
      module procedure leq_int_auto_diff_real_15var_order1
   end interface operator(.le.)

   interface operator(.ge.)
      module procedure geq_self
      module procedure geq_auto_diff_real_15var_order1_real_dp
      module procedure geq_real_dp_auto_diff_real_15var_order1
      module procedure geq_auto_diff_real_15var_order1_int
      module procedure geq_int_auto_diff_real_15var_order1
   end interface operator(.ge.)

   interface make_unop
      module procedure make_unary_operator
   end interface make_unop

   interface make_binop
      module procedure make_binary_operator
   end interface make_binop

   interface operator(-)
      module procedure unary_minus_self
   end interface operator(-)

   interface exp
      module procedure exp_self
   end interface exp

   interface log
      module procedure log_self
   end interface log

   interface safe_log
      module procedure safe_log_self
   end interface safe_log

   interface log10
      module procedure log10_self
   end interface log10

   interface safe_log10
      module procedure safe_log10_self
   end interface safe_log10

   interface sin
      module procedure sin_self
   end interface sin

   interface cos
      module procedure cos_self
   end interface cos

   interface tan
      module procedure tan_self
   end interface tan

   interface sinh
      module procedure sinh_self
   end interface sinh

   interface cosh
      module procedure cosh_self
   end interface cosh

   interface tanh
      module procedure tanh_self
   end interface tanh

   interface asin
      module procedure asin_self
   end interface asin

   interface acos
      module procedure acos_self
   end interface acos

   interface atan
      module procedure atan_self
   end interface atan

   interface asinh
      module procedure asinh_self
   end interface asinh

   interface acosh
      module procedure acosh_self
   end interface acosh

   interface atanh
      module procedure atanh_self
   end interface atanh

   interface sqrt
      module procedure sqrt_self
   end interface sqrt

   interface pow2
      module procedure pow2_self
   end interface pow2

   interface pow3
      module procedure pow3_self
   end interface pow3

   interface pow4
      module procedure pow4_self
   end interface pow4

   interface pow5
      module procedure pow5_self
   end interface pow5

   interface pow6
      module procedure pow6_self
   end interface pow6

   interface pow7
      module procedure pow7_self
   end interface pow7

   interface abs
      module procedure abs_self
   end interface abs

   interface operator(+)
      module procedure add_self
      module procedure add_self_real
      module procedure add_real_self
      module procedure add_self_int
      module procedure add_int_self
   end interface operator(+)

   interface operator(-)
      module procedure sub_self
      module procedure sub_self_real
      module procedure sub_real_self
      module procedure sub_self_int
      module procedure sub_int_self
   end interface operator(-)

   interface operator(*)
      module procedure mul_self
      module procedure mul_self_real
      module procedure mul_real_self
      module procedure mul_self_int
      module procedure mul_int_self
   end interface operator(*)

   interface operator(/)
      module procedure div_self
      module procedure div_self_real
      module procedure div_real_self
      module procedure div_self_int
      module procedure div_int_self
   end interface operator(/)

   interface operator(**)
      module procedure pow_self
      module procedure pow_self_real
      module procedure pow_real_self
      module procedure pow_self_int
      module procedure pow_int_self
   end interface operator(**)

   interface max
      module procedure max_self
      module procedure max_self_real
      module procedure max_real_self
      module procedure max_self_int
      module procedure max_int_self
   end interface max

   interface min
      module procedure min_self
      module procedure min_self_real
      module procedure min_real_self
      module procedure min_self_int
      module procedure min_int_self
   end interface min

   interface dim
      module procedure dim_self
      module procedure dim_self_real
      module procedure dim_real_self
      module procedure dim_self_int
      module procedure dim_int_self
   end interface dim

   interface pow
      module procedure pow_self
      module procedure pow_self_real
      module procedure pow_real_self
      module procedure pow_self_int
      module procedure pow_int_self
   end interface pow

   contains

   subroutine assign_from_self(this, other)
      type(auto_diff_real_15var_order1), intent(out) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      this%val = other%val
      this%d1Array = other%d1Array
   end subroutine assign_from_self

   subroutine assign_from_real_dp(this, other)
      type(auto_diff_real_15var_order1), intent(out) :: this
      real(dp), intent(in) :: other
      this%val = other
      this%d1Array = 0.0_dp
   end subroutine assign_from_real_dp

   subroutine assign_from_int(this, other)
      type(auto_diff_real_15var_order1), intent(out) :: this
      integer, intent(in) :: other
      this%val = other
      this%d1Array = 0.0_dp
   end subroutine assign_from_int

   function equal_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val == other%val)
   end function equal_self

   function equal_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val == other)
   end function equal_auto_diff_real_15var_order1_real_dp

   function equal_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this == other%val)
   end function equal_real_dp_auto_diff_real_15var_order1

   function equal_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val == other)
   end function equal_auto_diff_real_15var_order1_int

   function equal_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this == other%val)
   end function equal_int_auto_diff_real_15var_order1

   function neq_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val /= other%val)
   end function neq_self

   function neq_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val /= other)
   end function neq_auto_diff_real_15var_order1_real_dp

   function neq_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this /= other%val)
   end function neq_real_dp_auto_diff_real_15var_order1

   function neq_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val /= other)
   end function neq_auto_diff_real_15var_order1_int

   function neq_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this /= other%val)
   end function neq_int_auto_diff_real_15var_order1

   function greater_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val > other%val)
   end function greater_self

   function greater_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val > other)
   end function greater_auto_diff_real_15var_order1_real_dp

   function greater_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this > other%val)
   end function greater_real_dp_auto_diff_real_15var_order1

   function greater_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val > other)
   end function greater_auto_diff_real_15var_order1_int

   function greater_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this > other%val)
   end function greater_int_auto_diff_real_15var_order1

   function less_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val < other%val)
   end function less_self

   function less_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val < other)
   end function less_auto_diff_real_15var_order1_real_dp

   function less_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this < other%val)
   end function less_real_dp_auto_diff_real_15var_order1

   function less_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val < other)
   end function less_auto_diff_real_15var_order1_int

   function less_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this < other%val)
   end function less_int_auto_diff_real_15var_order1

   function leq_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val <= other%val)
   end function leq_self

   function leq_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val <= other)
   end function leq_auto_diff_real_15var_order1_real_dp

   function leq_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this <= other%val)
   end function leq_real_dp_auto_diff_real_15var_order1

   function leq_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val <= other)
   end function leq_auto_diff_real_15var_order1_int

   function leq_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this <= other%val)
   end function leq_int_auto_diff_real_15var_order1

   function geq_self(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this%val >= other%val)
   end function geq_self

   function geq_auto_diff_real_15var_order1_real_dp(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      real(dp), intent(in) :: other
      logical :: z
      z = (this%val >= other)
   end function geq_auto_diff_real_15var_order1_real_dp

   function geq_real_dp_auto_diff_real_15var_order1(this, other) result(z)
      real(dp), intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this >= other%val)
   end function geq_real_dp_auto_diff_real_15var_order1

   function geq_auto_diff_real_15var_order1_int(this, other) result(z)
      type(auto_diff_real_15var_order1), intent(in) :: this
      integer, intent(in) :: other
      logical :: z
      z = (this%val >= other)
   end function geq_auto_diff_real_15var_order1_int

   function geq_int_auto_diff_real_15var_order1(this, other) result(z)
      integer, intent(in) :: this
      type(auto_diff_real_15var_order1), intent(in) :: other
      logical :: z
      z = (this >= other%val)
   end function geq_int_auto_diff_real_15var_order1

   function make_unary_operator(x, z_val, z_d1x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: z_val
      real(dp), intent(in) :: z_d1x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = z_val
      unary%d1Array(1:15) = x%d1Array(1:15)*z_d1x
   end function make_unary_operator

   function make_binary_operator(x, y, z_val, z_d1x, z_d1y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      real(dp), intent(in) :: z_val
      real(dp), intent(in) :: z_d1x
      real(dp), intent(in) :: z_d1y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = z_val
      binary%d1Array(1:15) = x%d1Array(1:15)*z_d1x + y%d1Array(1:15)*z_d1y
   end function make_binary_operator

   function unary_minus_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = -x%val
      unary%d1Array(1:15) = -x%d1Array(1:15)
   end function unary_minus_self

   function exp_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = exp(x%val)
      unary%val = q0
      unary%d1Array(1:15) = q0*x%d1Array(1:15)
   end function exp_self

   function log_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = log(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(x%val)
   end function log_self

   function safe_log_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = safe_log(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(x%val)
   end function safe_log_self

   function log10_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = powm1(ln10)
      unary%val = q0*log(x%val)
      unary%d1Array(1:15) = q0*x%d1Array(1:15)*powm1(x%val)
   end function log10_self

   function safe_log10_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = powm1(ln10)
      unary%val = q0*safe_log(x%val)
      unary%d1Array(1:15) = q0*x%d1Array(1:15)*powm1(x%val)
   end function safe_log10_self

   function sin_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = sin(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*cos(x%val)
   end function sin_self

   function cos_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = cos(x%val)
      unary%d1Array(1:15) = -x%d1Array(1:15)*sin(x%val)
   end function cos_self

   function tan_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = tan(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(pow2(cos(x%val)))
   end function tan_self

   function sinh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = sinh(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*cosh(x%val)
   end function sinh_self

   function cosh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = cosh(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*sinh(x%val)
   end function cosh_self

   function tanh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = tanh(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(pow2(cosh(x%val)))
   end function tanh_self

   function asin_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = asin(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(sqrt(1 - pow2(x%val)))
   end function asin_self

   function acos_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = acos(x%val)
      unary%d1Array(1:15) = -x%d1Array(1:15)*powm1(sqrt(1 - pow2(x%val)))
   end function acos_self

   function atan_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = atan(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(pow2(x%val) + 1)
   end function atan_self

   function asinh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = asinh(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(sqrt(pow2(x%val) + 1))
   end function asinh_self

   function acosh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = acosh(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*powm1(sqrt(pow2(x%val) - 1))
   end function acosh_self

   function atanh_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = atanh(x%val)
      unary%d1Array(1:15) = -x%d1Array(1:15)*powm1(pow2(x%val) - 1)
   end function atanh_self

   function sqrt_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = sqrt(x%val)
      unary%val = q0
      unary%d1Array(1:15) = 0.5_dp*x%d1Array(1:15)*powm1(q0)
   end function sqrt_self

   function pow2_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow2(x%val)
      unary%d1Array(1:15) = 2*x%d1Array(1:15)*x%val
   end function pow2_self

   function pow3_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow3(x%val)
      unary%d1Array(1:15) = 3*x%d1Array(1:15)*pow2(x%val)
   end function pow3_self

   function pow4_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow4(x%val)
      unary%d1Array(1:15) = 4*x%d1Array(1:15)*pow3(x%val)
   end function pow4_self

   function pow5_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow5(x%val)
      unary%d1Array(1:15) = 5*x%d1Array(1:15)*pow4(x%val)
   end function pow5_self

   function pow6_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow6(x%val)
      unary%d1Array(1:15) = 6*x%d1Array(1:15)*pow5(x%val)
   end function pow6_self

   function pow7_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow7(x%val)
      unary%d1Array(1:15) = 7*x%d1Array(1:15)*pow6(x%val)
   end function pow7_self

   function abs_self(x) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = Abs(x%val)
      unary%d1Array(1:15) = x%d1Array(1:15)*sgn(x%val)
   end function abs_self

   function add_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = x%val + y%val
      binary%d1Array(1:15) = x%d1Array(1:15) + y%d1Array(1:15)
   end function add_self

   function add_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = x%val + y
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function add_self_real

   function add_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = x%val + z
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function add_real_self

   function add_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = x%val + y_dp
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function add_self_int

   function add_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = x%val + y_dp
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function add_int_self

   function sub_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = x%val - y%val
      binary%d1Array(1:15) = x%d1Array(1:15) - y%d1Array(1:15)
   end function sub_self

   function sub_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = x%val - y
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function sub_self_real

   function sub_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = -x%val + z
      unary%d1Array(1:15) = -x%d1Array(1:15)
   end function sub_real_self

   function sub_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = x%val - y_dp
      unary%d1Array(1:15) = x%d1Array(1:15)
   end function sub_self_int

   function sub_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = -x%val + y_dp
      unary%d1Array(1:15) = -x%d1Array(1:15)
   end function sub_int_self

   function mul_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = x%val*y%val
      binary%d1Array(1:15) = x%d1Array(1:15)*y%val + x%val*y%d1Array(1:15)
   end function mul_self

   function mul_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = x%val*y
      unary%d1Array(1:15) = x%d1Array(1:15)*y
   end function mul_self_real

   function mul_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = x%val*z
      unary%d1Array(1:15) = x%d1Array(1:15)*z
   end function mul_real_self

   function mul_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = x%val*y_dp
      unary%d1Array(1:15) = x%d1Array(1:15)*y_dp
   end function mul_self_int

   function mul_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = x%val*y_dp
      unary%d1Array(1:15) = x%d1Array(1:15)*y_dp
   end function mul_int_self

   function div_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      real(dp) :: q0
      q0 = powm1(y%val)
      binary%val = q0*x%val
      binary%d1Array(1:15) = q0*x%d1Array(1:15) - x%val*y%d1Array(1:15)*powm1(pow2(y%val))
   end function div_self

   function div_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = powm1(y)
      unary%val = q0*x%val
      unary%d1Array(1:15) = q0*x%d1Array(1:15)
   end function div_self_real

   function div_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = z*powm1(x%val)
      unary%d1Array(1:15) = -x%d1Array(1:15)*z*powm1(pow2(x%val))
   end function div_real_self

   function div_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      real(dp) :: q0
      y_dp = y
      q0 = powm1(y_dp)
      unary%val = q0*x%val
      unary%d1Array(1:15) = q0*x%d1Array(1:15)
   end function div_self_int

   function div_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = y_dp*powm1(x%val)
      unary%d1Array(1:15) = -x%d1Array(1:15)*y_dp*powm1(pow2(x%val))
   end function div_int_self

   function pow_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      real(dp) :: q0
      q0 = pow(x%val, y%val)
      binary%val = q0
      binary%d1Array(1:15) = q0*(x%d1Array(1:15)*y%val*powm1(x%val) + y%d1Array(1:15)*log(x%val))
   end function pow_self

   function pow_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = pow(x%val, y)
      unary%d1Array(1:15) = x%d1Array(1:15)*y*pow(x%val, y - 1)
   end function pow_self_real

   function pow_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = pow(z, x%val)
      unary%val = q0
      unary%d1Array(1:15) = q0*x%d1Array(1:15)*log(z)
   end function pow_real_self

   function pow_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = pow(x%val, y_dp)
      unary%d1Array(1:15) = x%d1Array(1:15)*y_dp*pow(x%val, y_dp - 1)
   end function pow_self_int

   function pow_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      real(dp) :: q0
      y_dp = z
      q0 = pow(y_dp, x%val)
      unary%val = q0
      unary%d1Array(1:15) = q0*x%d1Array(1:15)*log(y_dp)
   end function pow_int_self

   function max_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = Max(x%val, y%val)
      binary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(x%val - y%val) + y%d1Array(1:15)*Heaviside(-x%val + y%val)
   end function max_self

   function max_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = Max(x%val, y)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(x%val - y)
   end function max_self_real

   function max_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = Max(x%val, z)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(x%val - z)
   end function max_real_self

   function max_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = Max(x%val, y_dp)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(x%val - y_dp)
   end function max_self_int

   function max_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = Max(x%val, y_dp)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(x%val - y_dp)
   end function max_int_self

   function min_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      binary%val = Min(x%val, y%val)
      binary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(-x%val + y%val) + y%d1Array(1:15)*Heaviside(x%val - y%val)
   end function min_self

   function min_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      unary%val = Min(x%val, y)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(-x%val + y)
   end function min_self_real

   function min_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      unary%val = Min(x%val, z)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(-x%val + z)
   end function min_real_self

   function min_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = y
      unary%val = Min(x%val, y_dp)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(-x%val + y_dp)
   end function min_self_int

   function min_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      y_dp = z
      unary%val = Min(x%val, y_dp)
      unary%d1Array(1:15) = x%d1Array(1:15)*Heaviside(-x%val + y_dp)
   end function min_int_self

   function dim_self(x, y) result(binary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1), intent(in) :: y
      type(auto_diff_real_15var_order1) :: binary
      real(dp) :: q0
      q0 = x%val - y%val
      binary%val = -0.5_dp*y%val + 0.5_dp*x%val + 0.5_dp*Abs(q0)
      binary%d1Array(1:15) = -0.5_dp*y%d1Array(1:15) + 0.5_dp*x%d1Array(1:15) + 0.5_dp*(x%d1Array(1:15) - y%d1Array(1:15))*sgn(q0)
   end function dim_self

   function dim_self_real(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      real(dp), intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = x%val - y
      unary%val = -0.5_dp*y + 0.5_dp*x%val + 0.5_dp*Abs(q0)
      unary%d1Array(1:15) = 0.5_dp*x%d1Array(1:15)*(sgn(q0) + 1)
   end function dim_self_real

   function dim_real_self(z, x) result(unary)
      real(dp), intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: q0
      q0 = x%val - z
      unary%val = -0.5_dp*x%val + 0.5_dp*z + 0.5_dp*Abs(q0)
      unary%d1Array(1:15) = 0.5_dp*x%d1Array(1:15)*(sgn(q0) - 1)
   end function dim_real_self

   function dim_self_int(x, y) result(unary)
      type(auto_diff_real_15var_order1), intent(in) :: x
      integer, intent(in) :: y
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      real(dp) :: q0
      y_dp = y
      q0 = x%val - y_dp
      unary%val = -0.5_dp*y_dp + 0.5_dp*x%val + 0.5_dp*Abs(q0)
      unary%d1Array(1:15) = 0.5_dp*x%d1Array(1:15)*(sgn(q0) + 1)
   end function dim_self_int

   function dim_int_self(z, x) result(unary)
      integer, intent(in) :: z
      type(auto_diff_real_15var_order1), intent(in) :: x
      type(auto_diff_real_15var_order1) :: unary
      real(dp) :: y_dp
      real(dp) :: q0
      y_dp = z
      q0 = x%val - y_dp
      unary%val = -0.5_dp*x%val + 0.5_dp*y_dp + 0.5_dp*Abs(q0)
      unary%d1Array(1:15) = 0.5_dp*x%d1Array(1:15)*(sgn(q0) - 1)
   end function dim_int_self

end module auto_diff_real_15var_order1_module