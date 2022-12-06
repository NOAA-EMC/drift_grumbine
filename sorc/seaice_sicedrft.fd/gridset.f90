      SUBROUTINE gridset(lats, lons, lats0, lons0, dx, dy)
!     Assign initial positions to the virtual floes.
!     Robert Grumbine 4 April 1994.
!     Variant for assigning points on a lat-long grid
!     Robert Grumbine 7 May 2012 

      IMPLICIT none
      INCLUDE "sicedrft.inc"

      REAL lats(nx*ny), lons(nx*ny), lats0(nx*ny), lons0(nx*ny)
      REAL dx(nx*ny), dy(nx*ny)

      INTEGER i, j, k
      REAL tlat, tlon
      REAL x, y, e 

      e = sqrt(eccen2)
      k = 0
      lons = 0
      lats = 0
      lons0 = 0
      lats0 = 0

      DO j = 1, ny
      DO i = 1, nx
        k = k + 1
        y = yorig + j*deltay
        x = xorig + i*deltax
        CALL mapxy(x, y, tlat, tlon, slat, slon, sgn, e, rearth)
        lons(k)  = tlon
        lons0(k) = lons(k)
        lats(k)  = tlat
        lats0(k) = lats(k)
!D        PRINT *,"grid ",i,j,tlon, tlat, lons(k), lats(k), 
!D     1            lons0(k), lats0(k)
      ENDDO
      ENDDO

      DO i = 1, k
        dx(i) = 0.0
        dy(i) = 0.0
        IF (lons(i) .LT. 0) THEN
          lons(i)  = lons(i)  + 360.
          lons0(i) = lons0(i) + 360.
        ENDIF
        IF (lons0(i) .LT. 0) THEN
          lons(i)  = lons(i)  + 360.
          lons0(i) = lons0(i) + 360.
        ENDIF
        IF (lats(i) .LT. -90.0) THEN
          PRINT *,"lats ",i,lats(i),lons(i)-360.
        ENDIF
        IF (lats(i) .GT. 90.0) THEN
          PRINT *,"lats ",i,lats(i),lons(i)
        ENDIF
      ENDDO
    
!D      PRINT *,'max lon = ', MINVAL(lons), MAXVAL(lons)
!D      PRINT *,'max lat = ', MINVAL(lats), MAXVAL(lats)
!D      PRINT *,'max lon0 = ', MINVAL(lons0), MAXVAL(lons0)
!D      PRINT *,'max lat0 = ', MINVAL(lats0), MAXVAL(lats0)
      IF (MAXVAL(lats) .GT. 90.0 .OR. MINVAL(lats) .LT. -90.0 ) THEN 
        PRINT *,'lats off planet, according to maxval, minval'
      ENDIF

      RETURN
      END
