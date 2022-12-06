      SUBROUTINE uice(ug, vg, ui, vi, nlong, nlat)
!     Compute the motion of the non-interacting floes.
!     Bob Grumbine 17 September 1993.
!     U10 wind rule implemented 15 March 2007 

      IMPLICIT none
!D      INCLUDE "sicedrft.inc"

!     Declare the arguments
      INTEGER nlat, nlong
      REAL ug(nlong, nlat), vg(nlong, nlat)
      REAL ui(nlong, nlat), vi(nlong, nlat)

!     Declare local utility variables
      INTEGER i, j

!     Declare the flow model.
      REAL pi, betar
      REAL alpha1, beta1
      REAL alpha2, beta2
! These are the geostrophic wind values, superceded 15 March 2007
!OLD      PARAMETER (alpha1 = 0.008)
!OLD      PARAMETER (beta1  = 8.0)
!OLD      PARAMETER (alpha2 = 0.0303)
!OLD      PARAMETER (beta2  = -23.4)
      PARAMETER (alpha1 = 0.01468)
      PARAMETER (beta1  = 28.0)
      PARAMETER (alpha2 = 0.01468)
      PARAMETER (beta2  = -28.0)

      PARAMETER (pi    = 3.141592654)

!     Operational Code.
!     Compute the gridded ice drift velocity field. Note j convention is
!       reversed from MRF standard, and runs south to north.
!     Northern Hemisphere
      betar = pi*beta1/180.
      DO j = nlat/2+1, nlat
        DO i = 1, nlong
          ui(i,j) = alpha1*(COS(betar)*ug(i,j)+SIN(betar)*vg(i,j))
          vi(i,j) = alpha1*(-SIN(betar)*ug(i,j)+COS(betar)*vg(i,j))
        ENDDO
      ENDDO
!     Southern Hemisphere
      betar = pi*beta2/180.
      DO j = 2, nlat/2
        DO i = 1, nlong
          ui(i,j) = alpha2*(COS(betar)*ug(i,j)+SIN(betar)*vg(i,j))
          vi(i,j) = alpha2*(-SIN(betar)*ug(i,j)+COS(betar)*vg(i,j))
        ENDDO
      ENDDO

!CD      PRINT *,'debug max, min u, v ',MAXVAL(ui), MINVAL(ui), MAXVAL(vi), MINVAL(vi)

      RETURN
      END
