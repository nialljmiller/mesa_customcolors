      subroutine do_RGBI3P_db(MD,NXD,NYD,XD,YD,ZD,NIP,XI,YI, ZI,IER, WK)
!
! Rectangular-grid bivariate interpolation
! (a master subroutine of the RGBI3P/RGSF3P_db subroutine package)
!
! Hiroshi Akima
! U.S. Department of Commerce, NTIA/ITS
! Version of 1995/08
!
! This subroutine performs interpolation of a bivariate function,
! z(x,y), on a rectangular grid in the x-y plane.  It is based on
! the revised Akima method.
!
! In this subroutine, the interpolating function is a piecewise
! function composed of a set of bicubic (bivariate third-degree)
! polynomials, each applicable to a rectangle of the input grid
! in the x-y plane.  Each polynomial is determined locally.
!
! This subroutine has the accuracy of a bicubic polynomial, i.e.,
! it interpolates accurately when all data points lie on a
! surface of a bicubic polynomial.
!
! The grid lines can be unevenly spaced.
!
! The input arguments are
!   MD  = mode of computation
!       = 1 for new XD, YD, or ZD data (default)
!       = 2 for old XD, YD, and ZD data,
!   NXD = number of the input-grid data points in the x
!         coordinate (must be 2 or greater),
!   NYD = number of the input-grid data points in the y
!         coordinate (must be 2 or greater),
!   XD  = array of dimension NXD containing the x coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   YD  = array of dimension NYD containing the y coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   ZD  = two-dimensional array of dimension NXD*NYD
!         containing the z(x,y) values at the input-grid data
!         points,
!   NIP = number of the output points at which interpolation
!         of the z value is desired (must be 1 or greater),
!   XI  = array of dimension NIP containing the x coordinates
!         of the output points,
!   YI  = array of dimension NIP containing the y coordinates
!         of the output points.
!
! The output arguments are
!   ZI  = array of dimension NIP where the interpolated z
!         values at the output points are to be stored,
!   IER = error flag
!       = 0 for no errors
!       = 1 for NXD = 1 or less
!       = 2 for NYD = 1 or less
!       = 3 for identical XD values or
!               XD values out of sequence
!       = 4 for identical YD values or
!               YD values out of sequence
!       = 5 for NIP = 0 or less.
!
! The other argument is
!   WK  = three dimensional array of dimension 3*NXD*NYD used
!         internally as a work area.
!
! The very first call to this subroutine and the call with a new
! XD, YD, and ZD array must be made with MD=1.  The call with MD=2
! must be preceded by another call with the same XD, YD, and ZD
! arrays.  Between the call with MD=2 and its preceding call, the
! WK array must not be disturbed.
!
! The constant in the parameter statement below is
!   NIPIMX = maximum number of output points to be processed
!            at a time.
! The constant value has been selected empirically.
!
! This subroutine calls the RGPD3P_db, RGLCTN_db, and RGPLNL_db subroutines.
!

! Specification statements
!     .. Parameters ..
      integer :: NIPIMX
      parameter (NIPIMX=51)

!     .. Scalar Arguments ..
      integer :: IER,MD,NIP,NXD,NYD

!     .. Array Arguments ..
      double precision :: WK(3,NXD,NYD),XD(NXD),XI(NIP),YD(NYD),YI(NIP),ZD(NXD,NYD),ZI(NIP)

!     .. Local Scalars ..
      integer :: IIP,IX,IY,NIPI

!     .. Local Arrays ..
      integer :: INXI(NIPIMX),INYI(NIPIMX)

!     .. External Subroutines ..
      EXTERNAL RGLCTN_db,RGPD3P_db,RGPLNL_db

!     .. Intrinsic Functions ..
      INTRINSIC MIN

! Preliminary processing
! Error check
      if (NXD <= 1) GOTO 40
      if (NYD <= 1) GOTO 50
      do IX = 2,NXD
          if (XD(IX) <= XD(IX-1)) GOTO 60
      end do
      do IY = 2,NYD
          if (YD(IY) <= YD(IY-1)) GOTO 70
      end do
      if (NIP <= 0) GOTO 80
      IER = 0
! Calculation
! Estimates partial derivatives at all input-grid data points
! (for MD=1).
      if (MD /= 2) then
          call RGPD3P_db(NXD,NYD,XD,YD,ZD, WK)
!         call RGPD3P_db(NXD,NYD,XD,YD,ZD, PDD)
      end if
! DO-loop with respect to the output point
! Processes NIPIMX output points, at most, at a time.
      do IIP = 1,NIP,NIPIMX
          NIPI = MIN(NIP- (IIP-1),NIPIMX)
! Locates the output points.
          call RGLCTN_db(NXD,NYD,XD,YD,NIPI,XI(IIP),YI(IIP), INXI,INYI)
!         call RGLCTN_db(NXD,NYD,XD,YD,NIP,XI,YI, INXI,INYI)
! Calculates the z values at the output points.
          call RGPLNL_db(NXD,NYD,XD,YD,ZD,WK,NIPI,XI(IIP),YI(IIP),INXI,INYI, ZI(IIP))
!         call RGPLNL_db(NXD,NYD,XD,YD,ZD,PDD,NIP,XI,YI,INXI,INYI, ZI)
      end do
      return
! Error exit
   40 WRITE (*,FMT=9000)
      IER = 1
      GOTO 90
   50 WRITE (*,FMT=9010)
      IER = 2
      GOTO 90
   60 WRITE (*,FMT=9020) IX,XD(IX)
      IER = 3
      GOTO 90
   70 WRITE (*,FMT=9030) IY,YD(IY)
      IER = 4
      GOTO 90
   80 WRITE (*,FMT=9040)
      IER = 5
   90 WRITE (*,FMT=9050) NXD,NYD,NIP
      return
! Format statements for error messages
 9000 FORMAT (1X,/,'*** RGBI3P Error 1: NXD = 1 or less')
 9010 FORMAT (1X,/,'*** RGBI3P Error 2: NYD = 1 or less')
 9020 FORMAT (1X,/,'*** RGBI3P Error 3: Identical XD values or',
     &       ' XD values out of sequence',/,'    IX =',I6,',  XD(IX) =',
     &       E11.3)
 9030 FORMAT (1X,/,'*** RGBI3P Error 4: Identical YD values or',
     &       ' YD values out of sequence',/,'    IY =',I6,',  YD(IY) =',
     &       E11.3)
 9040 FORMAT (1X,/,'*** RGBI3P Error 5: NIP = 0 or less')
 9050 FORMAT ('    NXD =',I5,',  NYD =',I5,',  NIP =',I5,/)
      end subroutine do_RGBI3P_db


      subroutine do_RGSF3P_db(MD,NXD,NYD,XD,YD,ZD,NXI,XI,NYI,YI, ZI,IER, WK)
!
! Rectangular-grid surface fitting
! (a master subroutine of the RGBI3P/RGSF3P_db subroutine package)
!
! Hiroshi Akima
! U.S. Department of Commerce, NTIA/ITS
! Version of 1995/08
!
! This subroutine performs surface fitting by interpolating
! values of a bivariate function, z(x,y), on a rectangular grid
! in the x-y plane.  It is based on the revised Akima method.
!
! In this subroutine, the interpolating function is a piecewise
! function composed of a set of bicubic (bivariate third-degree)
! polynomials, each applicable to a rectangle of the input grid
! in the x-y plane.  Each polynomial is determined locally.
!
! This subroutine has the accuracy of a bicubic polynomial, i.e.,
! it fits the surface accurately when all data points lie on a
! surface of a bicubic polynomial.
!
! The grid lines of the input and output data can be unevenly
! spaced.
!
! The input arguments are
!   MD  = mode of computation
!       = 1 for new XD, YD, or ZD data (default)
!       = 2 for old XD, YD, and ZD data,
!   NXD = number of the input-grid data points in the x
!         coordinate (must be 2 or greater),
!   NYD = number of the input-grid data points in the y
!         coordinate (must be 2 or greater),
!   XD  = array of dimension NXD containing the x coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   YD  = array of dimension NYD containing the y coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   ZD  = two-dimensional array of dimension NXD*NYD
!         containing the z(x,y) values at the input-grid data
!         points,
!   NXI = number of output grid points in the x coordinate
!         (must be 1 or greater),
!   XI  = array of dimension NXI containing the x coordinates
!         of the output grid points,
!   NYI = number of output grid points in the y coordinate
!         (must be 1 or greater),
!   YI  = array of dimension NYI containing the y coordinates
!         of the output grid points.
!
! The output arguments are
!   ZI  = two-dimensional array of dimension NXI*NYI, where
!         the interpolated z values at the output grid
!         points are to be stored,
!   IER = error flag
!       = 0 for no error
!       = 1 for NXD = 1 or less
!       = 2 for NYD = 1 or less
!       = 3 for identical XD values or
!               XD values out of sequence
!       = 4 for identical YD values or
!               YD values out of sequence
!       = 5 for NXI = 0 or less
!       = 6 for NYI = 0 or less.
!
! The other argument is
!   WK  = three-dimensional array of dimension 3*NXD*NYD used
!         internally as a work area.
!
! The very first call to this subroutine and the call with a new
! XD, YD, or ZD array must be made with MD=1.  The call with MD=2
! must be preceded by another call with the same XD, YD, and ZD
! arrays.  Between the call with MD=2 and its preceding call, the
! WK array must not be disturbed.
!
! The constant in the parameter statement below is
!   NIPIMX = maximum number of output points to be processed
!            at a time.
! The constant value has been selected empirically.
!
! This subroutine calls the RGPD3P_db, RGLCTN_db, and RGPLNL_db subroutines.
!

! Specification statements
!     .. Parameters ..
      integer :: NIPIMX
      parameter (NIPIMX=51)

!     .. Scalar Arguments ..
      integer :: IER,MD,NXD,NXI,NYD,NYI

!     .. Array Arguments ..
      double precision :: WK(3,NXD,NYD),XD(NXD),XI(NXI),YD(NYD),YI(NYI),ZD(NXD,NYD),ZI(NXI,NYI)

!     .. Local Scalars ..
      integer :: IX,IXI,IY,IYI,NIPI

!     .. Local Arrays ..
      double precision :: YII(NIPIMX)
      integer :: INXI(NIPIMX),INYI(NIPIMX)

!     .. External Subroutines ..
      EXTERNAL RGLCTN_db,RGPD3P_db,RGPLNL_db

!     .. Intrinsic Functions ..
      INTRINSIC MIN

! Preliminary processing
! Error check
      if (NXD <= 1) GOTO 60
      if (NYD <= 1) GOTO 70
      do IX = 2,NXD
          if (XD(IX) <= XD(IX-1)) GOTO 80
      end do
      do IY = 2,NYD
          if (YD(IY) <= YD(IY-1)) GOTO 90
      end do
      if (NXI <= 0) GOTO 100
      if (NYI <= 0) GOTO 110
      IER = 0
! Calculation
! Estimates partial derivatives at all input-grid data points
! (for MD=1).
      if (MD /= 2) then
          call RGPD3P_db(NXD,NYD,XD,YD,ZD, WK)
!         call RGPD3P_db(NXD,NYD,XD,YD,ZD, PDD)
      end if
! Outermost DO-loop with respect to the y coordinate of the output
! grid points
      do IYI = 1,NYI
          do IXI = 1,NIPIMX
              YII(IXI) = YI(IYI)
          end do
! Second DO-loop with respect to the x coordinate of the output
! grid points
! Processes NIPIMX output-grid points, at most, at a time.
          do IXI = 1,NXI,NIPIMX
              NIPI = MIN(NXI- (IXI-1),NIPIMX)
! Locates the output-grid points.
              call RGLCTN_db(NXD,NYD,XD,YD,NIPI,XI(IXI),YII, INXI,INYI)
!             call RGLCTN_db(NXD,NYD,XD,YD,NIP,XI,YI, INXI,INYI)
! Calculates the z values at the output-grid points.
              call RGPLNL_db(NXD,NYD,XD,YD,ZD,WK,NIPI,XI(IXI),YII,INXI,INYI, ZI(IXI,IYI))
!             call RGPLNL_db(NXD,NYD,XD,YD,ZD,PDD,NIP,XI,YI,INXI,INYI, ZI)
          end do
      end do
      return
! Error exit
   60 WRITE (*,FMT=9000)
      IER = 1
      GOTO 120
   70 WRITE (*,FMT=9010)
      IER = 2
      GOTO 120
   80 WRITE (*,FMT=9020) IX,XD(IX)
      IER = 3
      GOTO 120
   90 WRITE (*,FMT=9030) IY,YD(IY)
      IER = 4
      GOTO 120
  100 WRITE (*,FMT=9040)
      IER = 5
      GOTO 120
  110 WRITE (*,FMT=9050)
      IER = 6
  120 WRITE (*,FMT=9060) NXD,NYD,NXI,NYI
      return
! Format statements for error messages
 9000 FORMAT (1X,/,'*** RGSF3P_db Error 1: NXD = 1 or less')
 9010 FORMAT (1X,/,'*** RGSF3P_db Error 2: NYD = 1 or less')
 9020 FORMAT (1X,/,'*** RGSF3P_db Error 3: Identical XD values or',
     &       ' XD values out of sequence',/,'    IX =',I6,',  XD(IX) =',E11.3)
 9030 FORMAT (1X,/,'*** RGSF3P_db Error 4: Identical YD values or',
     &       ' YD values out of sequence',/,'    IY =',I6,',  YD(IY) =',E11.3)
 9040 FORMAT (1X,/,'*** RGSF3P_db Error 5: NXI = 0 or less')
 9050 FORMAT (1X,/,'*** RGSF3P_db Error 6: NYI = 0 or less')
 9060 FORMAT ('    NXD =',I5,',  NYD =',I5,',  NXI =',I5,',  NYI =',I5,/)
      end subroutine do_RGSF3P_db


      subroutine RGPD3P_db(NXD,NYD,XD,YD,ZD, PDD)
!
! Partial derivatives of a bivariate function on a rectangular grid
! (a supporting subroutine of the RGBI3P/RGSF3P_db subroutine package)
!
! Hiroshi Akima
! U.S. Department of Commerce, NTIA/ITS
! Version of 1995/08
!
! This subroutine estimates three partial derivatives, zx, zy, and
! zxy, of a bivariate function, z(x,y), on a rectangular grid in
! the x-y plane.  It is based on the revised Akima method that has
! the accuracy of a bicubic polynomial.
!
! The input arguments are
!   NXD = number of the input-grid data points in the x
!         coordinate (must be 2 or greater),
!   NYD = number of the input-grid data points in the y
!         coordinate (must be 2 or greater),
!   XD  = array of dimension NXD containing the x coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   YD  = array of dimension NYD containing the y coordinates
!         of the input-grid data points (must be in a
!         monotonic increasing order),
!   ZD  = two-dimensional array of dimension NXD*NYD
!         containing the z(x,y) values at the input-grid data
!         points.
!
! The output argument is
!   PDD = three-dimensional array of dimension 3*NXD*NYD,
!         where the estimated zx, zy, and zxy values at the
!         input-grid data points are to be stored.
!

! Specification statements
!     .. Scalar Arguments ..
      integer :: NXD,NYD

!     .. Array Arguments ..
      double precision :: PDD(3,NXD,NYD),XD(NXD),YD(NYD),ZD(NXD,NYD)

!     .. Local Scalars ..
      double precision :: B00,B00X,B00Y,B01,B10,B11,CX1,CX2,CX3,CY1,CY2,
     &                 CY3,DISF,DNM,DZ00,DZ01,DZ02,DZ03,DZ10,DZ11,DZ12,
     &                 DZ13,DZ20,DZ21,DZ22,DZ23,DZ30,DZ31,DZ32,DZ33,
     &                 DZX10,DZX20,DZX30,DZXY11,DZXY12,DZXY13,DZXY21,
     &                 DZXY22,DZXY23,DZXY31,DZXY32,DZXY33,DZY01,DZY02,
     &                 DZY03,EPSLN,PEZX,PEZXY,PEZY,SMPEF,SMPEI,SMWTF,
     &                 SMWTI,SX,SXX,SXXY,SXXYY,SXY,SXYY,SXYZ,SXZ,SY,SYY,
     &                 SYZ,SZ,VOLF,WT,X0,X1,X2,X3,XX1,XX2,XX3,Y0,Y1,Y2,
     &                 Y3,Z00,Z01,Z02,Z03,Z10,Z11,Z12,Z13,Z20,Z21,Z22,
     &                 Z23,Z30,Z31,Z32,Z33,ZXDI,ZXYDI,ZYDI,ZZ0,ZZ1,ZZ2
      integer :: IPEX,IPEY,IX0,IX1,IX2,IX3,IY0,IY1,IY2,IY3,JPEXY,JXY,NX0,NY0

!     .. Local Arrays ..
      double precision :: B00XA(4),B00YA(4),B01A(4),B10A(4),CXA(3,4),
     &                 CYA(3,4),SXA(4),SXXA(4),SYA(4),SYYA(4),XA(3,4),
     &                 YA(3,4),Z0IA(3,4),ZI0A(3,4)
      integer :: IDLT(3,4)

!     .. Intrinsic Functions ..
      INTRINSIC        MAX

!     .. Statement Functions ..
      double precision :: Z2F,Z3F

! Data statements
      DATA ((IDLT(JXY,JPEXY),JPEXY=1,4),JXY=1,3)/-3,-2,-1,1,-2,-1,1,2,-1,1,2,3/

! Statement Function definitions
      Z2F(XX1,XX2,ZZ0,ZZ1) = (ZZ1-ZZ0)*XX2/XX1 + ZZ0
      Z3F(XX1,XX2,XX3,ZZ0,ZZ1,ZZ2) = ((ZZ2-ZZ0)* (XX3-XX1)/XX2-
     &                               (ZZ1-ZZ0)* (XX3-XX2)/XX1)*
     &                               (XX3/ (XX2-XX1)) + ZZ0

! Calculation
! Initial setting of some local variables
      NX0 = MAX(4,NXD)
      NY0 = MAX(4,NYD)
! Double DO-loop with respect to the input grid points
      do 60 IY0 = 1,NYD
          do 50 IX0 = 1,NXD
              X0 = XD(IX0)
              Y0 = YD(IY0)
              Z00 = ZD(IX0,IY0)
! Part 1.  Estimation of ZXDI
! Initial setting
              SMPEF = 0.0
              SMWTF = 0.0
              SMPEI = 0.0
              SMWTI = 0.0
! DO-loop with respect to the primary estimate
              do 10 IPEX = 1,4
! Selects necessary grid points in the x direction.
                  IX1 = IX0 + IDLT(1,IPEX)
                  IX2 = IX0 + IDLT(2,IPEX)
                  IX3 = IX0 + IDLT(3,IPEX)
                  if ((IX1 < 1) .or. (IX2 < 1) .or. (IX3 < 1) .or.
     &                (IX1 > NX0) .or. (IX2 > NX0) .or.
     &                (IX3 > NX0)) GOTO 10
! Selects and/or supplements the x and z values.
                  X1 = XD(IX1) - X0
                  Z10 = ZD(IX1,IY0)
                  if (NXD >= 4) then
                      X2 = XD(IX2) - X0
                      X3 = XD(IX3) - X0
                      Z20 = ZD(IX2,IY0)
                      Z30 = ZD(IX3,IY0)
                  else if (NXD == 3) then
                      X2 = XD(IX2) - X0
                      Z20 = ZD(IX2,IY0)
                      X3 = 2*XD(3) - XD(2) - X0
                      Z30 = Z3F(X1,X2,X3,Z00,Z10,Z20)
                  else if (NXD == 2) then
                      X2 = 2*XD(2) - XD(1) - X0
                      Z20 = Z2F(X1,X2,Z00,Z10)
                      X3 = 2*XD(1) - XD(2) - X0
                      Z30 = Z2F(X1,X3,Z00,Z10)
                  end if
                  DZX10 = (Z10-Z00)/X1
                  DZX20 = (Z20-Z00)/X2
                  DZX30 = (Z30-Z00)/X3
! Calculates the primary estimate of partial derivative zx as
! the coefficient of the bicubic polynomial.
                  CX1 = X2*X3/ ((X1-X2)* (X1-X3))
                  CX2 = X3*X1/ ((X2-X3)* (X2-X1))
                  CX3 = X1*X2/ ((X3-X1)* (X3-X2))
                  PEZX = CX1*DZX10 + CX2*DZX20 + CX3*DZX30
! Calculates the volatility factor and distance factor in the x
! direction for the primary estimate of zx.
                  SX = X1 + X2 + X3
                  SZ = Z00 + Z10 + Z20 + Z30
                  SXX = X1*X1 + X2*X2 + X3*X3
                  SXZ = X1*Z10 + X2*Z20 + X3*Z30
                  DNM = 4.0*SXX - SX*SX
                  B00 = (SXX*SZ-SX*SXZ)/DNM
                  B10 = (4.0*SXZ-SX*SZ)/DNM
                  DZ00 = Z00 - B00
                  DZ10 = Z10 - (B00+B10*X1)
                  DZ20 = Z20 - (B00+B10*X2)
                  DZ30 = Z30 - (B00+B10*X3)
                  VOLF = DZ00**2 + DZ10**2 + DZ20**2 + DZ30**2
                  DISF = SXX
! Calculates the EPSLN value, which is used to decide whether or
! not the volatility factor is essentially zero.
                  EPSLN = (Z00**2+Z10**2+Z20**2+Z30**2)*1.0E-12
! Accumulates the weighted primary estimates of zx and their
! weights.
                  if (VOLF > EPSLN) then
! - For a finite weight.
                      WT = 1.0/ (VOLF*DISF)
                      SMPEF = SMPEF + WT*PEZX
                      SMWTF = SMWTF + WT
                  else
! - For an infinite weight.
                      SMPEI = SMPEI + PEZX
                      SMWTI = SMWTI + 1.0
                  end if
! Saves the necessary values for estimating zxy
                  XA(1,IPEX) = X1
                  XA(2,IPEX) = X2
                  XA(3,IPEX) = X3
                  ZI0A(1,IPEX) = Z10
                  ZI0A(2,IPEX) = Z20
                  ZI0A(3,IPEX) = Z30
                  CXA(1,IPEX) = CX1
                  CXA(2,IPEX) = CX2
                  CXA(3,IPEX) = CX3
                  SXA(IPEX) = SX
                  SXXA(IPEX) = SXX
                  B00XA(IPEX) = B00
                  B10A(IPEX) = B10
   10         continue
! Calculates the final estimate of zx.
              if (SMWTI < 0.5) then
! - When no infinite weights exist.
                  ZXDI = SMPEF/SMWTF
              else
! - When infinite weights exist.
                  ZXDI = SMPEI/SMWTI
              end if
! End of Part 1.
! Part 2.  Estimation of ZYDI
! Initial setting
              SMPEF = 0.0
              SMWTF = 0.0
              SMPEI = 0.0
              SMWTI = 0.0
! DO-loop with respect to the primary estimate
              do 20 IPEY = 1,4
! Selects necessary grid points in the y direction.
                  IY1 = IY0 + IDLT(1,IPEY)
                  IY2 = IY0 + IDLT(2,IPEY)
                  IY3 = IY0 + IDLT(3,IPEY)
                  if ((IY1 < 1) .or. (IY2 < 1) .or. (IY3 < 1) .or.
     &                (IY1 > NY0) .or. (IY2 > NY0) .or.
     &                (IY3 > NY0)) GOTO 20
! Selects and/or supplements the y and z values.
                  Y1 = YD(IY1) - Y0
                  Z01 = ZD(IX0,IY1)
                  if (NYD >= 4) then
                      Y2 = YD(IY2) - Y0
                      Y3 = YD(IY3) - Y0
                      Z02 = ZD(IX0,IY2)
                      Z03 = ZD(IX0,IY3)
                  else if (NYD == 3) then
                      Y2 = YD(IY2) - Y0
                      Z02 = ZD(IX0,IY2)
                      Y3 = 2*YD(3) - YD(2) - Y0
                      Z03 = Z3F(Y1,Y2,Y3,Z00,Z01,Z02)
                  else if (NYD == 2) then
                      Y2 = 2*YD(2) - YD(1) - Y0
                      Z02 = Z2F(Y1,Y2,Z00,Z01)
                      Y3 = 2*YD(1) - YD(2) - Y0
                      Z03 = Z2F(Y1,Y3,Z00,Z01)
                  end if
                  DZY01 = (Z01-Z00)/Y1
                  DZY02 = (Z02-Z00)/Y2
                  DZY03 = (Z03-Z00)/Y3
! Calculates the primary estimate of partial derivative zy as
! the coefficient of the bicubic polynomial.
                  CY1 = Y2*Y3/ ((Y1-Y2)* (Y1-Y3))
                  CY2 = Y3*Y1/ ((Y2-Y3)* (Y2-Y1))
                  CY3 = Y1*Y2/ ((Y3-Y1)* (Y3-Y2))
                  PEZY = CY1*DZY01 + CY2*DZY02 + CY3*DZY03
! Calculates the volatility factor and distance factor in the y
! direction for the primary estimate of zy.
                  SY = Y1 + Y2 + Y3
                  SZ = Z00 + Z01 + Z02 + Z03
                  SYY = Y1*Y1 + Y2*Y2 + Y3*Y3
                  SYZ = Y1*Z01 + Y2*Z02 + Y3*Z03
                  DNM = 4.0*SYY - SY*SY
                  B00 = (SYY*SZ-SY*SYZ)/DNM
                  B01 = (4.0*SYZ-SY*SZ)/DNM
                  DZ00 = Z00 - B00
                  DZ01 = Z01 - (B00+B01*Y1)
                  DZ02 = Z02 - (B00+B01*Y2)
                  DZ03 = Z03 - (B00+B01*Y3)
                  VOLF = DZ00**2 + DZ01**2 + DZ02**2 + DZ03**2
                  DISF = SYY
! Calculates the EPSLN value, which is used to decide whether or
! not the volatility factor is essentially zero.
                  EPSLN = (Z00**2+Z01**2+Z02**2+Z03**2)*1.0E-12
! Accumulates the weighted primary estimates of zy and their
! weights.
                  if (VOLF > EPSLN) then
! - For a finite weight.
                      WT = 1.0/ (VOLF*DISF)
                      SMPEF = SMPEF + WT*PEZY
                      SMWTF = SMWTF + WT
                  else
! - For an infinite weight.
                      SMPEI = SMPEI + PEZY
                      SMWTI = SMWTI + 1.0
                  end if
! Saves the necessary values for estimating zxy
                  YA(1,IPEY) = Y1
                  YA(2,IPEY) = Y2
                  YA(3,IPEY) = Y3
                  Z0IA(1,IPEY) = Z01
                  Z0IA(2,IPEY) = Z02
                  Z0IA(3,IPEY) = Z03
                  CYA(1,IPEY) = CY1
                  CYA(2,IPEY) = CY2
                  CYA(3,IPEY) = CY3
                  SYA(IPEY) = SY
                  SYYA(IPEY) = SYY
                  B00YA(IPEY) = B00
                  B01A(IPEY) = B01
   20         continue
! Calculates the final estimate of zy.
              if (SMWTI < 0.5) then
! - When no infinite weights exist.
                  ZYDI = SMPEF/SMWTF
              else
! - When infinite weights exist.
                  ZYDI = SMPEI/SMWTI
              end if
! End of Part 2.
! Part 3.  Estimation of ZXYDI
! Initial setting
              SMPEF = 0.0
              SMWTF = 0.0
              SMPEI = 0.0
              SMWTI = 0.0
! Outer DO-loops with respect to the primary estimates in the x
! direction
              do 40 IPEX = 1,4
                  IX1 = IX0 + IDLT(1,IPEX)
                  IX2 = IX0 + IDLT(2,IPEX)
                  IX3 = IX0 + IDLT(3,IPEX)
                  if ((IX1 < 1) .or. (IX2 < 1) .or. (IX3 < 1) .or.
     &                (IX1 > NX0) .or. (IX2 > NX0) .or.
     &                (IX3 > NX0)) GOTO 40
! Retrieves the necessary values for estimating zxy in the x
! direction.
                  X1 = XA(1,IPEX)
                  X2 = XA(2,IPEX)
                  X3 = XA(3,IPEX)
                  Z10 = ZI0A(1,IPEX)
                  Z20 = ZI0A(2,IPEX)
                  Z30 = ZI0A(3,IPEX)
                  CX1 = CXA(1,IPEX)
                  CX2 = CXA(2,IPEX)
                  CX3 = CXA(3,IPEX)
                  SX = SXA(IPEX)
                  SXX = SXXA(IPEX)
                  B00X = B00XA(IPEX)
                  B10 = B10A(IPEX)
! Inner DO-loops with respect to the primary estimates in the y
! direction
                  do 30 IPEY = 1,4
                      IY1 = IY0 + IDLT(1,IPEY)
                      IY2 = IY0 + IDLT(2,IPEY)
                      IY3 = IY0 + IDLT(3,IPEY)
                      if ((IY1 < 1) .or. (IY2 < 1) .or.
     &                    (IY3 < 1) .or. (IY1 > NY0) .or.
     &                    (IY2 > NY0) .or. (IY3 > NY0)) GOTO 30
! Retrieves the necessary values for estimating zxy in the y
! direction.
                      Y1 = YA(1,IPEY)
                      Y2 = YA(2,IPEY)
                      Y3 = YA(3,IPEY)
                      Z01 = Z0IA(1,IPEY)
                      Z02 = Z0IA(2,IPEY)
                      Z03 = Z0IA(3,IPEY)
                      CY1 = CYA(1,IPEY)
                      CY2 = CYA(2,IPEY)
                      CY3 = CYA(3,IPEY)
                      SY = SYA(IPEY)
                      SYY = SYYA(IPEY)
                      B00Y = B00YA(IPEY)
                      B01 = B01A(IPEY)
! Selects and/or supplements the z values.
                      if (NYD >= 4) then
                          Z11 = ZD(IX1,IY1)
                          Z12 = ZD(IX1,IY2)
                          Z13 = ZD(IX1,IY3)
                          if (NXD >= 4) then
                              Z21 = ZD(IX2,IY1)
                              Z22 = ZD(IX2,IY2)
                              Z23 = ZD(IX2,IY3)
                              Z31 = ZD(IX3,IY1)
                              Z32 = ZD(IX3,IY2)
                              Z33 = ZD(IX3,IY3)
                          else if (NXD == 3) then
                              Z21 = ZD(IX2,IY1)
                              Z22 = ZD(IX2,IY2)
                              Z23 = ZD(IX2,IY3)
                              Z31 = Z3F(X1,X2,X3,Z01,Z11,Z21)
                              Z32 = Z3F(X1,X2,X3,Z02,Z12,Z22)
                              Z33 = Z3F(X1,X2,X3,Z03,Z13,Z23)
                          else if (NXD == 2) then
                              Z21 = Z2F(X1,X2,Z01,Z11)
                              Z22 = Z2F(X1,X2,Z02,Z12)
                              Z23 = Z2F(X1,X2,Z03,Z13)
                              Z31 = Z2F(X1,X3,Z01,Z11)
                              Z32 = Z2F(X1,X3,Z02,Z12)
                              Z33 = Z2F(X1,X3,Z03,Z13)
                          end if
                      else if (NYD == 3) then
                          Z11 = ZD(IX1,IY1)
                          Z12 = ZD(IX1,IY2)
                          Z13 = Z3F(Y1,Y2,Y3,Z10,Z11,Z12)
                          if (NXD >= 4) then
                              Z21 = ZD(IX2,IY1)
                              Z22 = ZD(IX2,IY2)
                              Z31 = ZD(IX3,IY1)
                              Z32 = ZD(IX3,IY2)
                          else if (NXD == 3) then
                              Z21 = ZD(IX2,IY1)
                              Z22 = ZD(IX2,IY2)
                              Z31 = Z3F(X1,X2,X3,Z01,Z11,Z21)
                              Z32 = Z3F(X1,X2,X3,Z02,Z12,Z22)
                          else if (NXD == 2) then
                              Z21 = Z2F(X1,X2,Z01,Z11)
                              Z22 = Z2F(X1,X2,Z02,Z12)
                              Z31 = Z2F(X1,X3,Z01,Z11)
                              Z32 = Z2F(X1,X3,Z02,Z12)
                          end if
                          Z23 = Z3F(Y1,Y2,Y3,Z20,Z21,Z22)
                          Z33 = Z3F(Y1,Y2,Y3,Z30,Z31,Z32)
                      else if (NYD == 2) then
                          Z11 = ZD(IX1,IY1)
                          Z12 = Z2F(Y1,Y2,Z10,Z11)
                          Z13 = Z2F(Y1,Y3,Z10,Z11)
                          if (NXD >= 4) then
                              Z21 = ZD(IX2,IY1)
                              Z31 = ZD(IX3,IY1)
                          else if (NXD == 3) then
                              Z21 = ZD(IX2,IY1)
                              Z31 = Z3F(X1,X2,X3,Z01,Z11,Z21)
                          else if (NXD == 2) then
                              Z21 = Z2F(X1,X2,Z01,Z11)
                              Z31 = Z2F(X1,X3,Z01,Z11)
                          end if
                          Z22 = Z2F(Y1,Y2,Z20,Z21)
                          Z23 = Z2F(Y1,Y3,Z20,Z21)
                          Z32 = Z2F(Y1,Y2,Z30,Z31)
                          Z33 = Z2F(Y1,Y3,Z30,Z31)
                      end if
! Calculates the primary estimate of partial derivative zxy as
! the coefficient of the bicubic polynomial.
                      DZXY11 = (Z11-Z10-Z01+Z00)/ (X1*Y1)
                      DZXY12 = (Z12-Z10-Z02+Z00)/ (X1*Y2)
                      DZXY13 = (Z13-Z10-Z03+Z00)/ (X1*Y3)
                      DZXY21 = (Z21-Z20-Z01+Z00)/ (X2*Y1)
                      DZXY22 = (Z22-Z20-Z02+Z00)/ (X2*Y2)
                      DZXY23 = (Z23-Z20-Z03+Z00)/ (X2*Y3)
                      DZXY31 = (Z31-Z30-Z01+Z00)/ (X3*Y1)
                      DZXY32 = (Z32-Z30-Z02+Z00)/ (X3*Y2)
                      DZXY33 = (Z33-Z30-Z03+Z00)/ (X3*Y3)
                      PEZXY = CX1* (CY1*DZXY11+CY2*DZXY12+CY3*DZXY13) +
     &                        CX2* (CY1*DZXY21+CY2*DZXY22+CY3*DZXY23) +
     &                        CX3* (CY1*DZXY31+CY2*DZXY32+CY3*DZXY33)
! Calculates the volatility factor and distance factor in the x
! and y directions for the primary estimate of zxy.
                      B00 = (B00X+B00Y)/2.0
                      SXY = SX*SY
                      SXXY = SXX*SY
                      SXYY = SX*SYY
                      SXXYY = SXX*SYY
                      SXYZ = X1* (Y1*Z11+Y2*Z12+Y3*Z13) +
     &                       X2* (Y1*Z21+Y2*Z22+Y3*Z23) +
     &                       X3* (Y1*Z31+Y2*Z32+Y3*Z33)
                      B11 = (SXYZ-B00*SXY-B10*SXXY-B01*SXYY)/SXXYY
                      DZ00 = Z00 - B00
                      DZ01 = Z01 - (B00+B01*Y1)
                      DZ02 = Z02 - (B00+B01*Y2)
                      DZ03 = Z03 - (B00+B01*Y3)
                      DZ10 = Z10 - (B00+B10*X1)
                      DZ11 = Z11 - (B00+B01*Y1+X1* (B10+B11*Y1))
                      DZ12 = Z12 - (B00+B01*Y2+X1* (B10+B11*Y2))
                      DZ13 = Z13 - (B00+B01*Y3+X1* (B10+B11*Y3))
                      DZ20 = Z20 - (B00+B10*X2)
                      DZ21 = Z21 - (B00+B01*Y1+X2* (B10+B11*Y1))
                      DZ22 = Z22 - (B00+B01*Y2+X2* (B10+B11*Y2))
                      DZ23 = Z23 - (B00+B01*Y3+X2* (B10+B11*Y3))
                      DZ30 = Z30 - (B00+B10*X3)
                      DZ31 = Z31 - (B00+B01*Y1+X3* (B10+B11*Y1))
                      DZ32 = Z32 - (B00+B01*Y2+X3* (B10+B11*Y2))
                      DZ33 = Z33 - (B00+B01*Y3+X3* (B10+B11*Y3))
                      VOLF = DZ00**2 + DZ01**2 + DZ02**2 + DZ03**2 +
     &                       DZ10**2 + DZ11**2 + DZ12**2 + DZ13**2 +
     &                       DZ20**2 + DZ21**2 + DZ22**2 + DZ23**2 +
     &                       DZ30**2 + DZ31**2 + DZ32**2 + DZ33**2
                      DISF = SXX*SYY
! Calculates EPSLN.
                      EPSLN = (Z00**2+Z01**2+Z02**2+Z03**2+Z10**2+
     &                        Z11**2+Z12**2+Z13**2+Z20**2+Z21**2+Z22**2+
     &                        Z23**2+Z30**2+Z31**2+Z32**2+Z33**2)*
     &                        1.0E-12
! Accumulates the weighted primary estimates of zxy and their
! weights.
                      if (VOLF > EPSLN) then
! - For a finite weight.
                          WT = 1.0/ (VOLF*DISF)
                          SMPEF = SMPEF + WT*PEZXY
                          SMWTF = SMWTF + WT
                      else
! - For an infinite weight.
                          SMPEI = SMPEI + PEZXY
                          SMWTI = SMWTI + 1.0
                      end if
   30             continue
   40         continue
! Calculates the final estimate of zxy.
              if (SMWTI < 0.5) then
! - When no infinite weights exist.
                  ZXYDI = SMPEF/SMWTF
              else
! - When infinite weights exist.
                  ZXYDI = SMPEI/SMWTI
              end if
! End of Part 3
              PDD(1,IX0,IY0) = ZXDI
              PDD(2,IX0,IY0) = ZYDI
              PDD(3,IX0,IY0) = ZXYDI
   50     continue
   60 continue
      return
      end subroutine RGPD3P_db


      subroutine RGLCTN_db(NXD,NYD,XD,YD,NIP,XI,YI, INXI,INYI)
!
! Location of the desired points in a rectangular grid
! (a supporting subroutine of the RGBI3P/RGSF3P_db subroutine package)
!
! Hiroshi Akima
! U.S. Department of Commerce, NTIA/ITS
! Version of 1995/08
!
! This subroutine locates the desired points in a rectangular grid
! in the x-y plane.
!
! The grid lines can be unevenly spaced.
!
! The input arguments are
!   NXD  = number of the input-grid data points in the x
!          coordinate (must be 2 or greater),
!   NYD  = number of the input-grid data points in the y
!          coordinate (must be 2 or greater),
!   XD   = array of dimension NXD containing the x coordinates
!          of the input-grid data points (must be in a
!          monotonic increasing order),
!   YD   = array of dimension NYD containing the y coordinates
!          of the input-grid data points (must be in a
!          monotonic increasing order),
!   NIP  = number of the output points to be located (must be
!          1 or greater),
!   XI   = array of dimension NIP containing the x coordinates
!          of the output points to be located,
!   YI   = array of dimension NIP containing the y coordinates
!          of the output points to be located.
!
! The output arguments are
!   INXI = integer array of dimension NIP where the interval
!          numbers of the XI array elements are to be stored,
!   INYI = integer array of dimension NIP where the interval
!          numbers of the YI array elements are to be stored.
! The interval numbers are between 0 and NXD and between 0 and NYD,
! respectively.
!

! Specification statements
!     .. Scalar Arguments ..
      integer :: NIP,NXD,NYD

!     .. Array Arguments ..
      double precision :: XD(NXD),XI(NIP),YD(NYD),YI(NIP)
      integer :: INXI(NIP),INYI(NIP)

!     .. Local Scalars ..
      double precision :: XII,YII
      integer :: IIP,IMD,IMN,IMX,IXD,IYD,NINTX,NINTY

! DO-loop with respect to IIP, which is the point number of the
! output point
      do IIP = 1,NIP
          XII = XI(IIP)
          YII = YI(IIP)
! Checks if the x coordinate of the IIPth output point, XII, is
! in a new interval.  (NINTX is the new-interval flag.)
          if (IIP == 1) then
              NINTX = 1
          else
              NINTX = 0
              if (IXD == 0) then
                  if (XII > XD(1)) NINTX = 1
              else if (IXD < NXD) then
                  if ((XII < XD(IXD)) .or. (XII > XD(IXD+1))) NINTX = 1
              else
                  if (XII < XD(NXD)) NINTX = 1
              end if
          end if
! Locates the output point by binary search if XII is in a new
! interval.  Determines IXD for which XII lies between XD(IXD)
! and XD(IXD+1).
          if (NINTX == 1) then
              if (XII <= XD(1)) then
                  IXD = 0
              else if (XII < XD(NXD)) then
                  IMN = 1
                  IMX = NXD
                  IMD = (IMN+IMX)/2
   10             if (XII >= XD(IMD)) then
                      IMN = IMD
                  else
                      IMX = IMD
                  end if
                  IMD = (IMN+IMX)/2
                  if (IMD > IMN) GOTO 10
                  IXD = IMD
              else
                  IXD = NXD
              end if
          end if
          INXI(IIP) = IXD
! Checks if the y coordinate of the IIPth output point, YII, is
! in a new interval.  (NINTY is the new-interval flag.)
          if (IIP == 1) then
              NINTY = 1
          else
              NINTY = 0
              if (IYD == 0) then
                  if (YII > YD(1)) NINTY = 1
              else if (IYD < NYD) then
                  if ((YII < YD(IYD)) .or. (YII > YD(IYD+1))) NINTY = 1
              else
                  if (YII < YD(NYD)) NINTY = 1
              end if
          end if
! Locates the output point by binary search if YII is in a new
! interval.  Determines IYD for which YII lies between YD(IYD)
! and YD(IYD+1).
          if (NINTY == 1) then
              if (YII <= YD(1)) then
                  IYD = 0
              else if (YII < YD(NYD)) then
                  IMN = 1
                  IMX = NYD
                  IMD = (IMN+IMX)/2
   20             if (YII >= YD(IMD)) then
                      IMN = IMD
                  else
                      IMX = IMD
                  end if
                  IMD = (IMN+IMX)/2
                  if (IMD > IMN) GOTO 20
                  IYD = IMD
              else
                  IYD = NYD
              end if
          end if
          INYI(IIP) = IYD
      end do
      return
      end subroutine RGLCTN_db


      subroutine RGPLNL_db(NXD,NYD,XD,YD,ZD,PDD,NIP,XI,YI,INXI,INYI, ZI)
!
! Polynomials for rectangular-grid bivariate interpolation and
! surface fitting
! (a supporting subroutine of the RGBI3P/RGSF3P_db subroutine package)
!
! Hiroshi Akima
! U.S. Department of Commerce, NTIA/ITS
! Version of 1995/08
!
! This subroutine determines a polynomial in x and y for a rectangle
! of the input grid in the x-y plane and calculates the z value for
! the desired points by evaluating the polynomial for rectangular-
! grid bivariate interpolation and surface fitting.
!
! The input arguments are
!   NXD  = number of the input-grid data points in the x
!          coordinate (must be 2 or greater),
!   NYD  = number of the input-grid data points in the y
!          coordinate (must be 2 or greater),
!   XD   = array of dimension NXD containing the x coordinates
!          of the input-grid data points (must be in a
!          monotonic increasing order),
!   YD   = array of dimension NYD containing the y coordinates
!          of the input-grid data points (must be in a
!          monotonic increasing order),
!   ZD   = two-dimensional array of dimension NXD*NYD
!          containing the z(x,y) values at the input-grid data
!          points,
!   PDD  = three-dimensional array of dimension 3*NXD*NYD
!          containing the estimated zx, zy, and zxy values
!          at the input-grid data points,
!   NIP  = number of the output points at which interpolation
!          is to be performed,
!   XI   = array of dimension NIP containing the x coordinates
!          of the output points,
!   YI   = array of dimension NIP containing the y coordinates
!          of the output points,
!   INXI = integer array of dimension NIP containing the
!          interval numbers of the input grid intervals in the
!          x direction where the x coordinates of the output
!          points lie,
!   INYI = integer array of dimension NIP containing the
!          interval numbers of the input grid intervals in the
!          y direction where the y coordinates of the output
!          points lie.
!
! The output argument is
!   ZI   = array of dimension NIP, where the interpolated z
!          values at the output points are to be stored.
!

! Specification statements
!     .. Scalar Arguments ..
      integer :: NIP,NXD,NYD

!     .. Array Arguments ..
      double precision :: PDD(3,NXD,NYD),XD(NXD),XI(NIP),YD(NYD),YI(NIP),ZD(NXD,NYD),ZI(NIP)
      integer :: INXI(NIP),INYI(NIP)

!     .. Local Scalars ..
      double precision :: A,B,C,D,DX,DXSQ,DY,DYSQ,P00,P01,P02,P03,P10,P11,
     &                 P12,P13,P20,P21,P22,P23,P30,P31,P32,P33,Q0,Q1,Q2,
     &                 Q3,U,V,X0,XII,Y0,YII,Z00,Z01,Z0DX,Z0DY,Z10,Z11,
     &                 Z1DX,Z1DY,ZDXDY,ZII,ZX00,ZX01,ZX0DY,ZX10,ZX11,
     &                 ZX1DY,ZXY00,ZXY01,ZXY10,ZXY11,ZY00,ZY01,ZY0DX,
     &                 ZY10,ZY11,ZY1DX
      integer :: IIP,IXD0,IXD1,IXDI,IXDIPV,IYD0,IYD1,IYDI,IYDIPV

!     .. Intrinsic Functions ..
      INTRINSIC MAX

! Calculation
! Outermost DO-loop with respect to the output point
      do IIP = 1,NIP
          XII = XI(IIP)
          YII = YI(IIP)
          if (IIP == 1) then
              IXDIPV = -1
              IYDIPV = -1
          else
              IXDIPV = IXDI
              IYDIPV = IYDI
          end if
          IXDI = INXI(IIP)
          IYDI = INYI(IIP)
! Retrieves the z and partial derivative values at the origin of
! the coordinate for the rectangle.
          if (IXDI /= IXDIPV .or. IYDI /= IYDIPV) then
              IXD0 = MAX(1,IXDI)
              IYD0 = MAX(1,IYDI)
              X0 = XD(IXD0)
              Y0 = YD(IYD0)
              Z00 = ZD(IXD0,IYD0)
              ZX00 = PDD(1,IXD0,IYD0)
              ZY00 = PDD(2,IXD0,IYD0)
              ZXY00 = PDD(3,IXD0,IYD0)
          end if
! Case 1.  When the rectangle is inside the data area in both the
! x and y directions.
          if ((IXDI > 0.and.IXDI < NXD) .and. (IYDI > 0.and.IYDI < NYD)) then
! Retrieves the z and partial derivative values at the other three
! vertices of the rectangle.
              if (IXDI /= IXDIPV .or. IYDI /= IYDIPV) then
                  IXD1 = IXD0 + 1
                  DX = XD(IXD1) - X0
                  DXSQ = DX*DX
                  IYD1 = IYD0 + 1
                  DY = YD(IYD1) - Y0
                  DYSQ = DY*DY
                  Z10 = ZD(IXD1,IYD0)
                  Z01 = ZD(IXD0,IYD1)
                  Z11 = ZD(IXD1,IYD1)
                  ZX10 = PDD(1,IXD1,IYD0)
                  ZX01 = PDD(1,IXD0,IYD1)
                  ZX11 = PDD(1,IXD1,IYD1)
                  ZY10 = PDD(2,IXD1,IYD0)
                  ZY01 = PDD(2,IXD0,IYD1)
                  ZY11 = PDD(2,IXD1,IYD1)
                  ZXY10 = PDD(3,IXD1,IYD0)
                  ZXY01 = PDD(3,IXD0,IYD1)
                  ZXY11 = PDD(3,IXD1,IYD1)
! Calculates the polynomial coefficients.
                  Z0DX = (Z10-Z00)/DX
                  Z1DX = (Z11-Z01)/DX
                  Z0DY = (Z01-Z00)/DY
                  Z1DY = (Z11-Z10)/DY
                  ZX0DY = (ZX01-ZX00)/DY
                  ZX1DY = (ZX11-ZX10)/DY
                  ZY0DX = (ZY10-ZY00)/DX
                  ZY1DX = (ZY11-ZY01)/DX
                  ZDXDY = (Z1DY-Z0DY)/DX
                  A = ZDXDY - ZX0DY - ZY0DX + ZXY00
                  B = ZX1DY - ZX0DY - ZXY10 + ZXY00
                  C = ZY1DX - ZY0DX - ZXY01 + ZXY00
                  D = ZXY11 - ZXY10 - ZXY01 + ZXY00
                  P00 = Z00
                  P01 = ZY00
                  P02 = (2.0* (Z0DY-ZY00)+Z0DY-ZY01)/DY
                  P03 = (-2.0*Z0DY+ZY01+ZY00)/DYSQ
                  P10 = ZX00
                  P11 = ZXY00
                  P12 = (2.0* (ZX0DY-ZXY00)+ZX0DY-ZXY01)/DY
                  P13 = (-2.0*ZX0DY+ZXY01+ZXY00)/DYSQ
                  P20 = (2.0* (Z0DX-ZX00)+Z0DX-ZX10)/DX
                  P21 = (2.0* (ZY0DX-ZXY00)+ZY0DX-ZXY10)/DX
                  P22 = (3.0* (3.0*A-B-C)+D)/ (DX*DY)
                  P23 = (-6.0*A+2.0*B+3.0*C-D)/ (DX*DYSQ)
                  P30 = (-2.0*Z0DX+ZX10+ZX00)/DXSQ
                  P31 = (-2.0*ZY0DX+ZXY10+ZXY00)/DXSQ
                  P32 = (-6.0*A+3.0*B+2.0*C-D)/ (DXSQ*DY)
                  P33 = (2.0* (2.0*A-B-C)+D)/ (DXSQ*DYSQ)
              end if
! Evaluates the polynomial.
              U = XII - X0
              V = YII - Y0
              Q0 = P00 + V* (P01+V* (P02+V*P03))
              Q1 = P10 + V* (P11+V* (P12+V*P13))
              Q2 = P20 + V* (P21+V* (P22+V*P23))
              Q3 = P30 + V* (P31+V* (P32+V*P33))
              ZII = Q0 + U* (Q1+U* (Q2+U*Q3))
! End of Case 1
! Case 2.  When the rectangle is inside the data area in the x
! direction but outside in the y direction.
          else if ((IXDI > 0.and.IXDI < NXD) .and. (IYDI <= 0.or.IYDI >= NYD)) then
! Retrieves the z and partial derivative values at the other
! vertex of the semi-infinite rectangle.
              if (IXDI /= IXDIPV .or. IYDI /= IYDIPV) then
                  IXD1 = IXD0 + 1
                  DX = XD(IXD1) - X0
                  DXSQ = DX*DX
                  Z10 = ZD(IXD1,IYD0)
                  ZX10 = PDD(1,IXD1,IYD0)
                  ZY10 = PDD(2,IXD1,IYD0)
                  ZXY10 = PDD(3,IXD1,IYD0)
! Calculates the polynomial coefficients.
                  Z0DX = (Z10-Z00)/DX
                  ZY0DX = (ZY10-ZY00)/DX
                  P00 = Z00
                  P01 = ZY00
                  P10 = ZX00
                  P11 = ZXY00
                  P20 = (2.0* (Z0DX-ZX00)+Z0DX-ZX10)/DX
                  P21 = (2.0* (ZY0DX-ZXY00)+ZY0DX-ZXY10)/DX
                  P30 = (-2.0*Z0DX+ZX10+ZX00)/DXSQ
                  P31 = (-2.0*ZY0DX+ZXY10+ZXY00)/DXSQ
              end if
! Evaluates the polynomial.
              U = XII - X0
              V = YII - Y0
              Q0 = P00 + V*P01
              Q1 = P10 + V*P11
              Q2 = P20 + V*P21
              Q3 = P30 + V*P31
              ZII = Q0 + U* (Q1+U* (Q2+U*Q3))
! End of Case 2
! Case 3.  When the rectangle is outside the data area in the x
! direction but inside in the y direction.
          else if ((IXDI <= 0.or.IXDI >= NXD) .and. (IYDI > 0.and.IYDI < NYD)) then
! Retrieves the z and partial derivative values at the other
! vertex of the semi-infinite rectangle.
              if (IXDI /= IXDIPV .or. IYDI /= IYDIPV) then
                  IYD1 = IYD0 + 1
                  DY = YD(IYD1) - Y0
                  DYSQ = DY*DY
                  Z01 = ZD(IXD0,IYD1)
                  ZX01 = PDD(1,IXD0,IYD1)
                  ZY01 = PDD(2,IXD0,IYD1)
                  ZXY01 = PDD(3,IXD0,IYD1)
! Calculates the polynomial coefficients.
                  Z0DY = (Z01-Z00)/DY
                  ZX0DY = (ZX01-ZX00)/DY
                  P00 = Z00
                  P01 = ZY00
                  P02 = (2.0* (Z0DY-ZY00)+Z0DY-ZY01)/DY
                  P03 = (-2.0*Z0DY+ZY01+ZY00)/DYSQ
                  P10 = ZX00
                  P11 = ZXY00
                  P12 = (2.0* (ZX0DY-ZXY00)+ZX0DY-ZXY01)/DY
                  P13 = (-2.0*ZX0DY+ZXY01+ZXY00)/DYSQ
              end if
! Evaluates the polynomial.
              U = XII - X0
              V = YII - Y0
              Q0 = P00 + V* (P01+V* (P02+V*P03))
              Q1 = P10 + V* (P11+V* (P12+V*P13))
              ZII = Q0 + U*Q1
! End of Case 3
! Case 4.  When the rectangle is outside the data area in both the
! x and y direction.
          else if ((IXDI <= 0.or.IXDI >= NXD) .and. (IYDI <= 0.or.IYDI >= NYD)) then
! Calculates the polynomial coefficients.
              if (IXDI /= IXDIPV .or. IYDI /= IYDIPV) then
                  P00 = Z00
                  P01 = ZY00
                  P10 = ZX00
                  P11 = ZXY00
              end if
! Evaluates the polynomial.
              U = XII - X0
              V = YII - Y0
              Q0 = P00 + V*P01
              Q1 = P10 + V*P11
              ZII = Q0 + U*Q1
          end if
! End of Case 4
          ZI(IIP) = ZII
      end do
      return
      end subroutine RGPLNL_db
