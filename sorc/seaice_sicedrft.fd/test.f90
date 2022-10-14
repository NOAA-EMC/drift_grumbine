PROGRAM test
!Author: Robert Grumbine

  IMPLICIT none

  INTEGER npts
  PARAMETER (npts = 90)
  REAL x0(npts), y0(npts), x(npts), y(npts)
  REAL dx(npts), dy(npts)
  REAL dir(npts), dist(npts)

  INTEGER i

  DO i = 1, npts
    x0(i) = i*3.5
    y0(i) = 90. - i*0.5
    dx(i) = 0.0625*i
    dy(i) = 0.0625*i
  ENDDO
  x = x0 + dx
  y = y0 + dy
  PRINT *,'dx: ',maxval(dx), minval(dx)
  PRINT *,'dy: ',maxval(dy), minval(dy)
  PRINT *,'x: ',maxval(x), minval(x)
  PRINT *,'y: ',maxval(y), minval(y)

  CALL convert(x0, y0, dx, dy, x, y, npts, dir, dist)
  DO i = 1, npts
    PRINT *,dir(i), dist(i)
  ENDDO

END
