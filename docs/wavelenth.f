c
c      RGB VALUES FOR VISIBLE WAVELENGTHS   by Dan Bruton (astro@tamu.edu)
c
c      This program can be found at 
c      http://www.physics.sfasu.edu/astro/color.html
c      and was last updated on February 20, 1996.
c
c      This program will create a ppm (portable pixmap) image of a spectrum.
c      The spectrum is generated using approximate RGB values for visible 
c      wavelengths between 380 nm and 780 nm.
c      NetPBM's ppmtogif can be used to convert the ppm image
c      to a gif.  The red, green and blue values (RGB) are
c      assumed to vary linearly with wavelength (for GAMMA=1).  
c      NetPBM Software: ftp://ftp.cs.ubc.ca/ftp/archive/netpbm/
c
       IMPLICIT REAL*8 (a-h,o-z)
       REAL*8 CV(500,500,3)
c
c      IMAGE INFO - WIDTH, HEIGHT, DEPTH, GAMMA
c
       M=400
       N=50
       MAX=255
       GAMMA=.80
c
c      WRITE OUTPUT TO PPM FILE
c
       OPEN(UNIT=20,FILE='temp.ppm',STATUS='UNKNOWN')
1      FORMAT(A10)
       WRITE(20,1) 'P3        ' 
       WRITE(20,1) '# temp.ppm'
       WRITE(20,*) M,N 
       WRITE(20,*) MAX 
       DO J=1,N
        DO I=1,M
c
c         WAVELENGTH = WL
c
            WL = 380. + REAL(I * 400. / M)

            IF ((WL.GE.380.).AND.(WL.LE.440.)) THEN 
              R = -1.*(WL-440.)/(440.-380.)
              G = 0.
              B = 1.
            ENDIF
            IF ((WL.GE.440.).AND.(WL.LE.490.)) THEN
              R = 0.
              G = (WL-440.)/(490.-440.)
              B = 1.
            ENDIF
            IF ((WL.GE.490.).AND.(WL.LE.510.)) THEN 
              R = 0.
              G = 1.
              B = -1.*(WL-510.)/(510.-490.)
            ENDIF
            IF ((WL.GE.510.).AND.(WL.LE.580.)) THEN 
              R = (WL-510.)/(580.-510.)
              G = 1.
              B = 0.
            ENDIF
            IF ((WL.GE.580.).AND.(WL.LE.645.)) THEN
              R = 1.
              G = -1.*(WL-645.)/(645.-580.)
              B = 0.
            ENDIF
            IF ((WL.GE.645.).AND.(WL.LE.780.)) THEN
              R = 1.
              G = 0.
              B = 0.
            ENDIF
c
c      LET THE INTENSITY SSS FALL OFF NEAR THE VISION LIMITS
c
         IF (WL.GT.700.) THEN
            SSS=.3+.7* (780.-WL)/(780.-700.)
         ELSE IF (WL.LT.420.) THEN
            SSS=.3+.7*(WL-380.)/(420.-380.)
         ELSE
            SSS=1.
         ENDIF
c
c      GAMMA ADJUST AND WRITE IMAGE TO AN ARRAY
c
         CV(I,J,1)=(SSS*R)**GAMMA
         CV(I,J,2)=(SSS*G)**GAMMA
         CV(I,J,3)=(SSS*B)**GAMMA
        ENDDO
       ENDDO
c
c      WRITE IMAGE TO PPM FILE
c
       DO J=1,N
        DO I=1,M
           WL = 380. + REAL(I * 400. / M)        
           IR=INT(MAX*CV(I,J,1))
           IG=INT(MAX*CV(I,J,2))
           IB=INT(MAX*CV(I,J,3))
c
c      ITYPE=1 - PLAIN SPECTUM
c      ITYPE=2 - MARK SPECTRUM AT 100 nm INTEVALS
c      ITYPE=3 - HYDROGEN BALMER EMISSION SPECTRA
c      ITYPE=4 - HYDROGEN BALMER ABSORPTION SPECTRA
c  
         ITYPE=4
         IF (ITYPE.EQ.2) THEN
            DO K=400,700,100
              IF ((ABS(INT(WL)-K).LT.1).AND.(J.LE.20)) THEN
               IR=MAX
               IG=MAX
               IB=MAX
              ENDIF
            ENDDO
         ELSEIF (ITYPE.EQ.3) THEN
            IF ((ABS(WL-656.).GT.1.).and.(ABS(WL-486.).GT.1.).and.
     *          (ABS(WL-433.).GT.1.).and.(ABS(WL-410.).GT.1.)
     *           .AND.(ABS(WL-396.).GT.1.)) THEN
              IR = 0
              IG = 0
              IB = 0
            ENDIF
         ELSEIF (ITYPE.EQ.4) THEN
            IF ((ABS(WL-656.).LT.1.1).or.(ABS(WL-486.).LT.1.1).or.
     *          (ABS(WL-433.).LT.1.1).or.(ABS(WL-410.).LT.1.1)
     *           .or.(ABS(WL-396.).LT.1.1)) THEN
              IR = 0
              IG = 0
              IB = 0
            ENDIF
         ENDIF

         WRITE(20,*) IR, IG, IB
        ENDDO
       ENDDO
       STOP
       END 
