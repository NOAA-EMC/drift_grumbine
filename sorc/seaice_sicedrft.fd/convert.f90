SUBROUTINE convert(x0, y0, dx, dy, x, y, npts, dir, dist)
!Author: Robert Grumbine

  IMPLICIT none

  INTEGER npts
  REAL x0(npts), y0(npts), x(npts), y(npts)
  REAL dx(npts), dy(npts)
  REAL dir(npts), dist(npts)

  REAL kmtonm
  PARAMETER (kmtonm = 1. /  1.852 )

  REAL xp(npts), yp(npts)
  REAL dxnm(npts), dynm(npts)
  REAL dummy, wdir, arcdis
  INTEGER i

  xp = x0 + dx
  yp = y0 + dy
  DO i = 1, npts
    dxnm(i) = kmtonm * arcdis(x0(i), y0(i), xp(i), y0(i))
    dynm(i) = kmtonm * arcdis(x0(i), y0(i), x0(i), yp(i))
    dxnm(i) = SIGN(dxnm(i), x0(i)-xp(i))
    dynm(i) = SIGN(dynm(i), y0(i)-yp(i))

    dir(i)  = wdir(-dxnm(i), -dynm(i), dummy)
    dist(i) = kmtonm * arcdis(x0(i), y0(i), x(i), y(i))
  ENDDO

  RETURN
END SUBROUTINE convert
