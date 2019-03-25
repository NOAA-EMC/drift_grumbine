PROGRAM unit
! generate dummy inputs for making tests of the program
  IMPLICIT none
  INCLUDE "sicedrft.inc"

  INTEGER nlat, nlong, tlat, tlong, npts
  PARAMETER (nlat  = (lat2-lat1)/dlat + 1)
  PARAMETER (nlong = (long2-long1)/dlon  )
  PARAMETER (tlat  = 180./dlat + 1)
  PARAMETER (tlong = 360./dlon    )
  PARAMETER (npts  = nlat*nlong)
  REAL ua(nlong, nlat), va(nlong, nlat)

  INTEGER i

  ua = 5.0
  va = 5.0

  OPEN(FILE="fort.11", UNIT=11,FORM="UNFORMATTED", STATUS="NEW")
  OPEN(FILE="fort.12", UNIT=12,FORM="UNFORMATTED", STATUS="NEW")
  DO i = 1, 16*2
    WRITE(11) ua
    WRITE(12) va
  ENDDO

    
END
