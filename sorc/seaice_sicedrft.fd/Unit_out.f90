PROGRAM unit_out
! check dummy outputs for being nonzero
  IMPLICIT none
  INCLUDE "sicedrft.inc"

  REAL dx(nx*ny), dy(nx*ny)
  INTEGER i

  OPEN(FILE="grid_ds", UNIT=11, FORM="UNFORMATTED", STATUS="OLD")
  DO i = 1, 16*2
    READ(11) dx
    READ(11) dy
    PRINT *,'i = ',i,MAXVAL(dx), MAXVAL(dy)
  ENDDO

    
END
