      SUBROUTINE HEADBLD(SCINAME,BASANG,VOLNAM,IBEGYR,
     X     IBEGMNT,IBEGDAY,IBEGHR,IBEGMIN,IBEGSEC,IENDYR,
     X     IENDMNT,IENDDAY,IENDHR,IENDMIN,IENDSEC,XMIN,
     X     XMAX,NUMX,ISPCX,YMIN,YMAX,NUMY,ISPCY,ZMIN,
     X     ZMAX,NUMZ,ISPCZ,NFLD,FLDNAM,ISCLFLD,NUMLND,
     X     NUMRAD,NAMLND,XLND,YLND,ZLND,RADSTN,SOURCE,
     X     PROJECT,TAPE,RADCON,VNYQ,LATDEG,LATMIN,LATSEC,LONDEG,
     X     LONMIN,LONSEC)
C     
C     THIS SUBROUTINE WILL CONSTRUCT A CEDRIC HEADER FROM THE
C     VARIABLES PASSED IN THE PARAMETER LIST 
C     
      PARAMETER (MAXFLD=25, NID=510)
      CHARACTER*4 PROJECT
      CHARACTER*6 SCINAME,NAMLND(7),RADSTN,TAPE
      CHARACTER*8 VOLNAM,FLDNAM(MAXFLD),IWHERE,CTEMP,SOURCE
      DIMENSION ISCLFLD(MAXFLD),XLND(7),YLND(7),ZLND(7)
      DIMENSION IDHEAD(NID)
      DATA IBIT,NBITS,NSKIP,LEN/0,16,0,510/
      DATA IGENSCL,IANGSCL/100,64/
      CHARACTER*2 TMPFLD
      integer i
C     
C     DETERMINE BYTE ORDERING OF MACHINE
C     
      CALL CBYTE(MBYTE)

      do i=1,510
         idhead(i)=0
      enddo
      
      TMPFLD = 'TE'
      read(TMPFLD,910) IDHEAD(1)
 910  format(A2)
      TMPFLD = 'ST'
      read(TMPFLD,910) IDHEAD(2)
      TMPFLD = 'VO'
      read(TMPFLD,910) IDHEAD(3)
      TMPFLD = 'LU'
      read(TMPFLD,910) IDHEAD(4)
      TMPFLD = 'CE'
      read(TMPFLD,910) IDHEAD(5)
      TMPFLD = 'DR'
      read(TMPFLD,910) IDHEAD(6)
      TMPFLD = 'IC'
      read(TMPFLD,910) IDHEAD(7)
      
      READ(PROJECT,23)IDHEAD(8),IDHEAD(9)
 23   FORMAT(2A2)
      
      READ(SCINAME,25)(IDHEAD(I),I=10,12)
      READ(RADSTN,25)(IDHEAD(I),I=13,15)
 25   FORMAT(3A2)

      READ(TAPE,25)(IDHEAD(I),I=18,20)

      IDHEAD(33)=LATDEG
      IDHEAD(34)=LATMIN
      IDHEAD(35)=LATSEC*IGENSCL
      IDHEAD(36)=LONDEG
      IDHEAD(37)=LONMIN
      IDHEAD(38)=LONSEC*IGENSCL

      CALL DATEE(IWHERE)
      WRITE(CTEMP,50)IWHERE
      READ(CTEMP,102)(IDHEAD(I),I=51,54)
 102  FORMAT(4A2)
      
      CALL CLOCK(IWHERE)
      WRITE(CTEMP,50)IWHERE
      READ(CTEMP,102)(IDHEAD(I),I=55,58)

      IDHEAD(61)=510

      TMPFLD = 'SN'
      read(TMPFLD,910) IDHEAD(62)
      
      READ(SOURCE,102)(IDHEAD(I),I=71,74)

      IF (VOLNAM.NE.'        ') THEN
         WRITE(CTEMP,50)VOLNAM
         READ(CTEMP,102)(IDHEAD(I),I=101,104)
      END IF
 50   FORMAT(A8)

      TMPFLD = 'CR'
      read(TMPFLD,910) IDHEAD(16)
      TMPFLD = 'T '
      read(TMPFLD,910) IDHEAD(17)
      IDHEAD(40)=NINT(BASANG*IANGSCL)
      IDHEAD(65)=3200
      IDHEAD(67)=-32768
      IDHEAD(68)=IGENSCL
      IDHEAD(69)=IANGSCL
      IDHEAD(106)=NUMZ
      
      IDHEAD(116)=IBEGYR
      IDHEAD(117)=IBEGMNT
      IDHEAD(118)=IBEGDAY
      IDHEAD(119)=IBEGHR
      IDHEAD(120)=IBEGMIN
      IDHEAD(121)=IBEGSEC
      
      IDHEAD(122)=IENDYR
      IDHEAD(123)=IENDMNT
      IDHEAD(124)=IENDDAY
      IDHEAD(125)=IENDHR
      IDHEAD(126)=IENDMIN
      IDHEAD(127)=IENDSEC
      
      IDHEAD(160)=INT(XMIN*IGENSCL)
      IDHEAD(161)=INT(XMAX*IGENSCL)
      IDHEAD(162)=NUMX
      IDHEAD(163)=ISPCX
      IDHEAD(164)=1
      
      IDHEAD(165)=INT(YMIN*IGENSCL)
      IDHEAD(166)=INT(YMAX*IGENSCL)
      IDHEAD(167)=NUMY
      IDHEAD(168)=ISPCY
      IDHEAD(169)=2
      
      IDHEAD(170)=ZMIN
      IDHEAD(171)=ZMAX
      IDHEAD(172)=NUMZ
      IDHEAD(173)=ISPCZ
      IDHEAD(174)=3
      
      IDHEAD(175)=NFLD
      
      IFLD=176
      DO 100 I=1,NFLD
         READ(FLDNAM(I),175)(IDHEAD(IFLD+ (I-1)*5 + J-1),J=1,4)
 175     FORMAT(4A2)
         IDHEAD(IFLD+ (I-1)*5 + 4)=ISCLFLD(I)
 100  CONTINUE
      
      IDHEAD(301)=NUMX*NUMY
      IDHEAD(302)=NUMLND
      IDHEAD(303)=NUMRAD

      IDHEAD(304)=VNYQ*IGENSCL
      IDHEAD(305)=RADCON*IGENSCL
      
      ILND=306
      DO 200 I=1,NUMLND
         READ(NAMLND(I),250)(IDHEAD(ILND + (I-1)*6 + J-1),J=1,3)
 250     FORMAT(3A2)
         IDHEAD(ILND + (I-1)*6 + 3)=NINT(XLND(I)*IGENSCL)
         IDHEAD(ILND + (I-1)*6 + 4)=NINT(YLND(I)*IGENSCL)
         IDHEAD(ILND + (I-1)*6 + 5)=ZLND(I)
 200  CONTINUE
      

C
C     SUMMARIZE DATASET
C
      CALL IMHSUM(6,IDHEAD)
      
      IF (MBYTE.EQ.0) THEN
C     
C     SHIFT CHARACTER STRINGS TO THE RIGHT ON BIG ENDIAN ARCHITECTURES
C     
         CALL SHIRBL(IDHEAD(  1),20)
         CALL SHIRBL(IDHEAD( 43),16)
         CALL SHIRBL(IDHEAD( 62), 1)
         CALL SHIRBL(IDHEAD( 66), 1)
         CALL SHIRBL(IDHEAD( 71),24)
         CALL SHIRBL(IDHEAD(101), 4)
         CALL SHIRBL(IDHEAD(151), 1)
C     
C     FIELD NAMES
C     
         K=IDHEAD(175)
         I=176
         DO 20 J=1,K
            CALL SHIRBL(IDHEAD(I),4)
            I=I+5
 20      CONTINUE
C     
C     LANDMARKS
C     
         K=IDHEAD(302)
         I=306
         DO 30 J=1,K
            CALL SHIRBL(IDHEAD(I),3)
            I=I+6
 30      CONTINUE
      END IF
      

C     
C     OUTPUT ID HEADER NOW
C     
      CALL SBYTES(IDHEAD,IDHEAD,IBIT,NBITS,NSKIP,LEN)
      CALL CWRITE(IDHEAD,LEN)
      
      
      RETURN
      
      END
      
            subroutine str2int(str,final_int)

      implicit none
      character*2 str
      integer*2 int1,int2,final_int

      int1 = iachar(str(1:1))
      int2 = iachar(str(2:2))
c      print *,'int:',int1,' ',int2
      final_int = int1*256+int2
      return
      end
