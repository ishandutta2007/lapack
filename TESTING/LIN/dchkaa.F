*> \brief \b DCHKAA
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*  Definition:
*  ===========
*
*       PROGRAM DCHKAA
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> DCHKAA is the main test program for the DOUBLE PRECISION LAPACK
*> linear equation routines
*>
*> The program must be driven by a short data file. The first 15 records
*> (not including the first comment  line) specify problem dimensions
*> and program options using list-directed input. The remaining lines
*> specify the LAPACK test paths and the number of matrix types to use
*> in testing.  An annotated example of a data file can be obtained by
*> deleting the first 3 characters from the following 40 lines:
*> Data file for testing DOUBLE PRECISION LAPACK linear eqn. routines
*> 7                      Number of values of M
*> 0 1 2 3 5 10 16        Values of M (row dimension)
*> 7                      Number of values of N
*> 0 1 2 3 5 10 16        Values of N (column dimension)
*> 1                      Number of values of NRHS
*> 2                      Values of NRHS (number of right hand sides)
*> 5                      Number of values of NB
*> 1 3 3 3 20             Values of NB (the blocksize)
*> 1 0 5 9 1              Values of NX (crossover point)
*> 3                      Number of values of RANK
*> 30 50 90               Values of rank (as a % of N)
*> 20.0                   Threshold value of test ratio
*> T                      Put T to test the LAPACK routines
*> T                      Put T to test the driver routines
*> T                      Put T to test the error exits
*> DGE   11               List types on next line if 0 < NTYPES < 11
*> DGB    8               List types on next line if 0 < NTYPES <  8
*> DGT   12               List types on next line if 0 < NTYPES < 12
*> DPO    9               List types on next line if 0 < NTYPES <  9
*> DPS    9               List types on next line if 0 < NTYPES <  9
*> DPP    9               List types on next line if 0 < NTYPES <  9
*> DPB    8               List types on next line if 0 < NTYPES <  8
*> DPT   12               List types on next line if 0 < NTYPES < 12
*> DSY   10               List types on next line if 0 < NTYPES < 10
*> DSR   10               List types on next line if 0 < NTYPES < 10
*> DSK   10               List types on next line if 0 < NTYPES < 10
*> DSA   10               List types on next line if 0 < NTYPES < 10
*> DS2   10               List types on next line if 0 < NTYPES < 10
*> DSP   10               List types on next line if 0 < NTYPES < 10
*> DTR   18               List types on next line if 0 < NTYPES < 18
*> DTP   18               List types on next line if 0 < NTYPES < 18
*> DTB   17               List types on next line if 0 < NTYPES < 17
*> DQR    8               List types on next line if 0 < NTYPES <  8
*> DRQ    8               List types on next line if 0 < NTYPES <  8
*> DLQ    8               List types on next line if 0 < NTYPES <  8
*> DQL    8               List types on next line if 0 < NTYPES <  8
*> DQP    6               List types on next line if 0 < NTYPES <  6
*> DQK    19              List types on next line if 0 < NTYPES <  19
*> DTZ    3               List types on next line if 0 < NTYPES <  3
*> DLS    6               List types on next line if 0 < NTYPES <  6
*> DEQ
*> DQT
*> DQX
*> DTQ
*> DXQ
*> DTS
*> DHH
*> \endverbatim
*
*  Parameters:
*  ==========
*
*> \verbatim
*>  NMAX    INTEGER
*>          The maximum allowable value for M and N.
*>
*>  MAXIN   INTEGER
*>          The number of different values that can be used for each of
*>          M, N, NRHS, NB, NX and RANK
*>
*>  MAXRHS  INTEGER
*>          The maximum number of right hand sides
*>
*>  MATMAX  INTEGER
*>          The maximum number of matrix types to use for testing
*>
*>  NIN     INTEGER
*>          The unit number for input
*>
*>  NOUT    INTEGER
*>          The unit number for output
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \ingroup double_lin
*
*  =====================================================================
      PROGRAM DCHKAA
*
*  -- LAPACK test routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
*  =====================================================================
*
*     .. Parameters ..
      INTEGER            NMAX
      PARAMETER          ( NMAX = 132 )
      INTEGER            MAXIN
      PARAMETER          ( MAXIN = 12 )
      INTEGER            MAXRHS
      PARAMETER          ( MAXRHS = 16 )
      INTEGER            MATMAX
      PARAMETER          ( MATMAX = 30 )
      INTEGER            NIN, NOUT
      PARAMETER          ( NIN = 5, NOUT = 6 )
      INTEGER            KDMAX
      PARAMETER          ( KDMAX = NMAX+( NMAX+1 ) / 4 )
*     ..
*     .. Local Scalars ..
      LOGICAL            FATAL, TSTCHK, TSTDRV, TSTERR
      CHARACTER          C1
      CHARACTER*2        C2
      CHARACTER*3        PATH
      CHARACTER*10       INTSTR
      CHARACTER*72       ALINE
      INTEGER            I, IC, J, K, LA, LAFAC, LDA, NB, NM, NMATS, NN,
     $                   NNB, NNB2, NNS, NRHS, NTYPES, NRANK,
     $                   VERS_MAJOR, VERS_MINOR, VERS_PATCH
      DOUBLE PRECISION   EPS, S1, S2, THREQ, THRESH
*     ..
*     .. Local Arrays ..
      LOGICAL            DOTYPE( MATMAX )
      INTEGER            IWORK( 25*NMAX ), MVAL( MAXIN ),
     $                   NBVAL( MAXIN ), NBVAL2( MAXIN ),
     $                   NSVAL( MAXIN ), NVAL( MAXIN ), NXVAL( MAXIN ),
     $                   RANKVAL( MAXIN ), PIV( NMAX )
*     ..
*     .. Allocatable Arrays ..
      INTEGER AllocateStatus
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: RWORK, S
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: E
      DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: A, B, WORK
*     ..
*     .. External Functions ..
      LOGICAL            LSAME, LSAMEN
      DOUBLE PRECISION   DLAMCH, DSECND
      EXTERNAL           LSAME, LSAMEN, DLAMCH, DSECND
*     ..
*     .. External Subroutines ..
      EXTERNAL           ALAREQ, DCHKEQ, DCHKGB, DCHKGE, DCHKGT, DCHKLQ,
     $                   DCHKORHR_COL, DCHKPB, DCHKPO, DCHKPS, DCHKPP,
     $                   DCHKPT, DCHKQ3, DCHKQP3RK, DCHKQL, DCHKQR,
     $                   DCHKRQ, DCHKSP, DCHKSY, DCHKSY_ROOK, DCHKSY_RK,
     $                   DCHKSY_AA, DCHKTB, DCHKTP, DCHKTR, DCHKTZ,
     $                   DDRVGB, DDRVGE, DDRVGT, DDRVLS, DDRVPB, DDRVPO,
     $                   DDRVPP, DDRVPT, DDRVSP, DDRVSY, DDRVSY_ROOK,
     $                   DDRVSY_RK, DDRVSY_AA, ILAVER, DCHKLQTP, DCHKQRT,
     $                   DCHKQRTP, DCHKLQT,DCHKTSQR
*     ..
*     .. Scalars in Common ..
      LOGICAL            LERR, OK
      CHARACTER*32       SRNAMT
      INTEGER            INFOT, NUNIT
*     ..
*     .. Arrays in Common ..
      INTEGER            IPARMS( 100 )
*     ..
*     .. Common blocks ..
      COMMON             / INFOC / INFOT, NUNIT, OK, LERR
      COMMON             / SRNAMC / SRNAMT
      COMMON             / CLAENV / IPARMS
*     ..
*     .. Data statements ..
      DATA               THREQ / 2.0D0 / , INTSTR / '0123456789' /
*     ..
*     ..
*     .. Allocate memory dynamically ..
*
      ALLOCATE ( A( ( KDMAX+1 )*NMAX, 7 ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
      ALLOCATE ( B( NMAX*MAXRHS, 4 ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
      ALLOCATE ( WORK( NMAX, 3*NMAX+MAXRHS+30 ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
      ALLOCATE ( E( NMAX ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
      ALLOCATE ( S( 2*NMAX ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
      ALLOCATE ( RWORK( 5*NMAX+2*MAXRHS ), STAT = AllocateStatus )
      IF (AllocateStatus /= 0) STOP "*** Not enough memory ***"
*
*     .. Executable Statements ..
*
      S1 = DSECND( )
      LDA = NMAX
      FATAL = .FALSE.
*
*     Read a dummy line.
*
      READ( NIN, FMT = * )
*
*     Report values of parameters.
*
      CALL ILAVER( VERS_MAJOR, VERS_MINOR, VERS_PATCH )
      WRITE( NOUT, FMT = 9994 ) VERS_MAJOR, VERS_MINOR, VERS_PATCH
*
*     Read the values of M
*
      READ( NIN, FMT = * )NM
      IF( NM.LT.1 ) THEN
         WRITE( NOUT, FMT = 9996 )' NM ', NM, 1
         NM = 0
         FATAL = .TRUE.
      ELSE IF( NM.GT.MAXIN ) THEN
         WRITE( NOUT, FMT = 9995 )' NM ', NM, MAXIN
         NM = 0
         FATAL = .TRUE.
      END IF
      READ( NIN, FMT = * )( MVAL( I ), I = 1, NM )
      DO 10 I = 1, NM
         IF( MVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )' M  ', MVAL( I ), 0
            FATAL = .TRUE.
         ELSE IF( MVAL( I ).GT.NMAX ) THEN
            WRITE( NOUT, FMT = 9995 )' M  ', MVAL( I ), NMAX
            FATAL = .TRUE.
         END IF
   10 CONTINUE
      IF( NM.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'M   ', ( MVAL( I ), I = 1, NM )
*
*     Read the values of N
*
      READ( NIN, FMT = * )NN
      IF( NN.LT.1 ) THEN
         WRITE( NOUT, FMT = 9996 )' NN ', NN, 1
         NN = 0
         FATAL = .TRUE.
      ELSE IF( NN.GT.MAXIN ) THEN
         WRITE( NOUT, FMT = 9995 )' NN ', NN, MAXIN
         NN = 0
         FATAL = .TRUE.
      END IF
      READ( NIN, FMT = * )( NVAL( I ), I = 1, NN )
      DO 20 I = 1, NN
         IF( NVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )' N  ', NVAL( I ), 0
            FATAL = .TRUE.
         ELSE IF( NVAL( I ).GT.NMAX ) THEN
            WRITE( NOUT, FMT = 9995 )' N  ', NVAL( I ), NMAX
            FATAL = .TRUE.
         END IF
   20 CONTINUE
      IF( NN.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'N   ', ( NVAL( I ), I = 1, NN )
*
*     Read the values of NRHS
*
      READ( NIN, FMT = * )NNS
      IF( NNS.LT.1 ) THEN
         WRITE( NOUT, FMT = 9996 )' NNS', NNS, 1
         NNS = 0
         FATAL = .TRUE.
      ELSE IF( NNS.GT.MAXIN ) THEN
         WRITE( NOUT, FMT = 9995 )' NNS', NNS, MAXIN
         NNS = 0
         FATAL = .TRUE.
      END IF
      READ( NIN, FMT = * )( NSVAL( I ), I = 1, NNS )
      DO 30 I = 1, NNS
         IF( NSVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )'NRHS', NSVAL( I ), 0
            FATAL = .TRUE.
         ELSE IF( NSVAL( I ).GT.MAXRHS ) THEN
            WRITE( NOUT, FMT = 9995 )'NRHS', NSVAL( I ), MAXRHS
            FATAL = .TRUE.
         END IF
   30 CONTINUE
      IF( NNS.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'NRHS', ( NSVAL( I ), I = 1, NNS )
*
*     Read the values of NB
*
      READ( NIN, FMT = * )NNB
      IF( NNB.LT.1 ) THEN
         WRITE( NOUT, FMT = 9996 )'NNB ', NNB, 1
         NNB = 0
         FATAL = .TRUE.
      ELSE IF( NNB.GT.MAXIN ) THEN
         WRITE( NOUT, FMT = 9995 )'NNB ', NNB, MAXIN
         NNB = 0
         FATAL = .TRUE.
      END IF
      READ( NIN, FMT = * )( NBVAL( I ), I = 1, NNB )
      DO 40 I = 1, NNB
         IF( NBVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )' NB ', NBVAL( I ), 0
            FATAL = .TRUE.
         END IF
   40 CONTINUE
      IF( NNB.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'NB  ', ( NBVAL( I ), I = 1, NNB )
*
*     Set NBVAL2 to be the set of unique values of NB
*
      NNB2 = 0
      DO 60 I = 1, NNB
         NB = NBVAL( I )
         DO 50 J = 1, NNB2
            IF( NB.EQ.NBVAL2( J ) )
     $         GO TO 60
   50    CONTINUE
         NNB2 = NNB2 + 1
         NBVAL2( NNB2 ) = NB
   60 CONTINUE
*
*     Read the values of NX
*
      READ( NIN, FMT = * )( NXVAL( I ), I = 1, NNB )
      DO 70 I = 1, NNB
         IF( NXVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )' NX ', NXVAL( I ), 0
            FATAL = .TRUE.
         END IF
   70 CONTINUE
      IF( NNB.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'NX  ', ( NXVAL( I ), I = 1, NNB )
*
*     Read the values of RANKVAL
*
      READ( NIN, FMT = * )NRANK
      IF( NN.LT.1 ) THEN
         WRITE( NOUT, FMT = 9996 )' NRANK ', NRANK, 1
         NRANK = 0
         FATAL = .TRUE.
      ELSE IF( NN.GT.MAXIN ) THEN
         WRITE( NOUT, FMT = 9995 )' NRANK ', NRANK, MAXIN
         NRANK = 0
         FATAL = .TRUE.
      END IF
      READ( NIN, FMT = * )( RANKVAL( I ), I = 1, NRANK )
      DO I = 1, NRANK
         IF( RANKVAL( I ).LT.0 ) THEN
            WRITE( NOUT, FMT = 9996 )' RANK  ', RANKVAL( I ), 0
            FATAL = .TRUE.
         ELSE IF( RANKVAL( I ).GT.100 ) THEN
            WRITE( NOUT, FMT = 9995 )' RANK  ', RANKVAL( I ), 100
            FATAL = .TRUE.
         END IF
      END DO
      IF( NRANK.GT.0 )
     $   WRITE( NOUT, FMT = 9993 )'RANK % OF N',
     $   ( RANKVAL( I ), I = 1, NRANK )
*
*     Read the threshold value for the test ratios.
*
      READ( NIN, FMT = * )THRESH
      WRITE( NOUT, FMT = 9992 )THRESH
*
*     Read the flag that indicates whether to test the LAPACK routines.
*
      READ( NIN, FMT = * )TSTCHK
*
*     Read the flag that indicates whether to test the driver routines.
*
      READ( NIN, FMT = * )TSTDRV
*
*     Read the flag that indicates whether to test the error exits.
*
      READ( NIN, FMT = * )TSTERR
*
      IF( FATAL ) THEN
         WRITE( NOUT, FMT = 9999 )
         STOP
      END IF
*
*     Calculate and print the machine dependent constants.
*
      EPS = DLAMCH( 'Underflow threshold' )
      WRITE( NOUT, FMT = 9991 )'underflow', EPS
      EPS = DLAMCH( 'Overflow threshold' )
      WRITE( NOUT, FMT = 9991 )'overflow ', EPS
      EPS = DLAMCH( 'Epsilon' )
      WRITE( NOUT, FMT = 9991 )'precision', EPS
      WRITE( NOUT, FMT = * )
*
   80 CONTINUE
*
*     Read a test path and the number of matrix types to use.
*
      READ( NIN, FMT = '(A72)', END = 140 )ALINE
      PATH = ALINE( 1: 3 )
      NMATS = MATMAX
      I = 3
   90 CONTINUE
      I = I + 1
      IF( I.GT.72 ) THEN
         NMATS = MATMAX
         GO TO 130
      END IF
      IF( ALINE( I: I ).EQ.' ' )
     $   GO TO 90
      NMATS = 0
  100 CONTINUE
      C1 = ALINE( I: I )
      DO 110 K = 1, 10
         IF( C1.EQ.INTSTR( K: K ) ) THEN
            IC = K - 1
            GO TO 120
         END IF
  110 CONTINUE
      GO TO 130
  120 CONTINUE
      NMATS = NMATS*10 + IC
      I = I + 1
      IF( I.GT.72 )
     $   GO TO 130
      GO TO 100
  130 CONTINUE
      C1 = PATH( 1: 1 )
      C2 = PATH( 2: 3 )
      NRHS = NSVAL( 1 )
*
*     Check first character for correct precision.
*
      IF( .NOT.LSAME( C1, 'Double precision' ) ) THEN
         WRITE( NOUT, FMT = 9990 )PATH
*
      ELSE IF( NMATS.LE.0 ) THEN
*
*        Check for a positive number of tests requested.
*
         WRITE( NOUT, FMT = 9989 )PATH
*
      ELSE IF( LSAMEN( 2, C2, 'GE' ) ) THEN
*
*        GE:  general matrices
*
         NTYPES = 11
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKGE( DOTYPE, NM, MVAL, NN, NVAL, NNB2, NBVAL2, NNS,
     $                   NSVAL, THRESH, TSTERR, LDA, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), B( 1, 1 ), B( 1, 2 ),
     $                   B( 1, 3 ), WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVGE( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), B( 1, 4 ), S, WORK,
     $                   RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'GB' ) ) THEN
*
*        GB:  general banded matrices
*
         LA = ( 2*KDMAX+1 )*NMAX
         LAFAC = ( 3*KDMAX+1 )*NMAX
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKGB( DOTYPE, NM, MVAL, NN, NVAL, NNB2, NBVAL2, NNS,
     $                   NSVAL, THRESH, TSTERR, A( 1, 1 ), LA,
     $                   A( 1, 3 ), LAFAC, B( 1, 1 ), B( 1, 2 ),
     $                   B( 1, 3 ), WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVGB( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                   A( 1, 1 ), LA, A( 1, 3 ), LAFAC, A( 1, 6 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), B( 1, 4 ), S,
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'GT' ) ) THEN
*
*        GT:  general tridiagonal matrices
*
         NTYPES = 12
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKGT( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   A( 1, 1 ), A( 1, 2 ), B( 1, 1 ), B( 1, 2 ),
     $                   B( 1, 3 ), WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVGT( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                   A( 1, 1 ), A( 1, 2 ), B( 1, 1 ), B( 1, 2 ),
     $                   B( 1, 3 ), WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'PO' ) ) THEN
*
*        PO:  positive definite matrices
*
         NTYPES = 9
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKPO( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                   THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                   A( 1, 3 ), B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVPO( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), B( 1, 4 ), S, WORK,
     $                   RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'PS' ) ) THEN
*
*        PS:  positive semi-definite matrices
*
         NTYPES = 9
*
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKPS( DOTYPE, NN, NVAL, NNB2, NBVAL2, NRANK,
     $                   RANKVAL, THRESH, TSTERR, LDA, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), PIV, WORK, RWORK,
     $                   NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'PP' ) ) THEN
*
*        PP:  positive definite packed matrices
*
         NTYPES = 9
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKPP( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   LDA, A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), WORK, RWORK,
     $                   IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVPP( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), B( 1, 4 ), S, WORK,
     $                   RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'PB' ) ) THEN
*
*        PB:  positive definite banded matrices
*
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKPB( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                   THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                   A( 1, 3 ), B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVPB( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), B( 1, 4 ), S, WORK,
     $                   RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'PT' ) ) THEN
*
*        PT:  positive definite tridiagonal matrices
*
         NTYPES = 12
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKPT( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVPT( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'SY' ) ) THEN
*
*        SY:  symmetric indefinite matrices,
*             with partial (Bunch-Kaufman) pivoting algorithm
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSY( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                   THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                   A( 1, 3 ), B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSY( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, IWORK,
     $                   NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'SR' ) ) THEN
*
*        SR:  symmetric indefinite matrices,
*             with bounded Bunch-Kaufman (rook) pivoting algorithm
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSY_ROOK(DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                       THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                       A( 1, 3 ), B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                       WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSY_ROOK( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                        LDA, A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                        B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                        WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'SK' ) ) THEN
*
*        SK:  symmetric indefinite matrices,
*             with bounded Bunch-Kaufman (rook) pivoting algorithm,
*             different matrix storage format than SR path version.
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSY_RK( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                      THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                      E, A( 1, 3 ), B( 1, 1 ), B( 1, 2 ),
     $                      B( 1, 3 ), WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSY_RK( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                      LDA, A( 1, 1 ), A( 1, 2 ), E, A( 1, 3 ),
     $                      B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                      WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'SA' ) ) THEN
*
*        SA:  symmetric indefinite matrices,
*             with partial (Aasen's) pivoting algorithm
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSY_AA( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS,
     $                         NSVAL, THRESH, TSTERR, LDA,
     $                         A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                         B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                         WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSY_AA( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                         LDA, A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                         B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                         WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
*
      ELSE IF( LSAMEN( 2, C2, 'S2' ) ) THEN
*
*        SA:  symmetric indefinite matrices,
*             with partial (Aasen's) pivoting algorithm
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSY_AA_2STAGE( DOTYPE, NN, NVAL, NNB2, NBVAL2,
     $                         NNS, NSVAL, THRESH, TSTERR, LDA,
     $                         A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                         B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                         WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSY_AA_2STAGE(
     $                         DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR,
     $                         LDA, A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                         B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                         WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
*
      ELSE IF( LSAMEN( 2, C2, 'SP' ) ) THEN
*
*        SP:  symmetric indefinite packed matrices,
*             with partial (Bunch-Kaufman) pivoting algorithm
*
         NTYPES = 10
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKSP( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   LDA, A( 1, 1 ), A( 1, 2 ), A( 1, 3 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), WORK, RWORK,
     $                   IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
         IF( TSTDRV ) THEN
            CALL DDRVSP( DOTYPE, NN, NVAL, NRHS, THRESH, TSTERR, LDA,
     $                   A( 1, 1 ), A( 1, 2 ), A( 1, 3 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, IWORK,
     $                   NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TR' ) ) THEN
*
*        TR:  triangular matrices
*
         NTYPES = 18
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKTR( DOTYPE, NN, NVAL, NNB2, NBVAL2, NNS, NSVAL,
     $                   THRESH, TSTERR, LDA, A( 1, 1 ), A( 1, 2 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), WORK, RWORK,
     $                   IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TP' ) ) THEN
*
*        TP:  triangular packed matrices
*
         NTYPES = 18
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKTP( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   LDA, A( 1, 1 ), A( 1, 2 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, IWORK,
     $                   NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TB' ) ) THEN
*
*        TB:  triangular banded matrices
*
         NTYPES = 17
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKTB( DOTYPE, NN, NVAL, NNS, NSVAL, THRESH, TSTERR,
     $                   LDA, A( 1, 1 ), A( 1, 2 ), B( 1, 1 ),
     $                   B( 1, 2 ), B( 1, 3 ), WORK, RWORK, IWORK,
     $                   NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QR' ) ) THEN
*
*        QR:  QR factorization
*
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKQR( DOTYPE, NM, MVAL, NN, NVAL, NNB, NBVAL, NXVAL,
     $                   NRHS, THRESH, TSTERR, NMAX, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), A( 1, 4 ), A( 1, 5 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), B( 1, 4 ),
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'LQ' ) ) THEN
*
*        LQ:  LQ factorization
*
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKLQ( DOTYPE, NM, MVAL, NN, NVAL, NNB, NBVAL, NXVAL,
     $                   NRHS, THRESH, TSTERR, NMAX, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), A( 1, 4 ), A( 1, 5 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), B( 1, 4 ),
     $                   WORK, RWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QL' ) ) THEN
*
*        QL:  QL factorization
*
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKQL( DOTYPE, NM, MVAL, NN, NVAL, NNB, NBVAL, NXVAL,
     $                   NRHS, THRESH, TSTERR, NMAX, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), A( 1, 4 ), A( 1, 5 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), B( 1, 4 ),
     $                   WORK, RWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'RQ' ) ) THEN
*
*        RQ:  RQ factorization
*
         NTYPES = 8
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKRQ( DOTYPE, NM, MVAL, NN, NVAL, NNB, NBVAL, NXVAL,
     $                   NRHS, THRESH, TSTERR, NMAX, A( 1, 1 ),
     $                   A( 1, 2 ), A( 1, 3 ), A( 1, 4 ), A( 1, 5 ),
     $                   B( 1, 1 ), B( 1, 2 ), B( 1, 3 ), B( 1, 4 ),
     $                   WORK, RWORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QP' ) ) THEN
*
*        QP:  QR factorization with pivoting
*
         NTYPES = 6
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKQ3( DOTYPE, NM, MVAL, NN, NVAL, NNB, NBVAL,
     $                   NXVAL, THRESH, A( 1, 1 ), A( 1, 2 ),
     $                   B( 1, 1 ), B( 1, 3 ), WORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QK' ) ) THEN
*
*        QK: truncated QR factorization with pivoting
*
         NTYPES = 19
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKQP3RK( DOTYPE, NM, MVAL, NN, NVAL, NNS, NSVAL,
     $                      NNB, NBVAL, NXVAL, THRESH, A( 1, 1 ),
     $                      A( 1, 2 ), B( 1, 1 ), B( 1, 2 ),
     $                      B( 1, 3 ), B( 1, 4 ),
     $                      WORK, IWORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TZ' ) ) THEN
*
*        TZ:  Trapezoidal matrix
*
         NTYPES = 3
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTCHK ) THEN
            CALL DCHKTZ( DOTYPE, NM, MVAL, NN, NVAL, THRESH, TSTERR,
     $                   A( 1, 1 ), A( 1, 2 ), B( 1, 1 ),
     $                   B( 1, 3 ), WORK, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'LS' ) ) THEN
*
*        LS:  Least squares drivers
*
         NTYPES = 6
         CALL ALAREQ( PATH, NMATS, DOTYPE, NTYPES, NIN, NOUT )
*
         IF( TSTDRV ) THEN
            CALL DDRVLS( DOTYPE, NM, MVAL, NN, NVAL, NNS, NSVAL, NNB,
     $                   NBVAL, NXVAL, THRESH, TSTERR, A( 1, 1 ),
     $                   A( 1, 2 ), B( 1, 1 ), B( 1, 2 ), B( 1, 3 ),
     $                   RWORK, RWORK( NMAX+1 ), NOUT )
         ELSE
            WRITE( NOUT, FMT = 9988 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'EQ' ) ) THEN
*
*        EQ:  Equilibration routines for general and positive definite
*             matrices (THREQ should be between 2 and 10)
*
         IF( TSTCHK ) THEN
            CALL DCHKEQ( THREQ, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QT' ) ) THEN
*
*        QT:  QRT routines for general matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKQRT( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                    NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'QX' ) ) THEN
*
*        QX:  QRT routines for triangular-pentagonal matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKQRTP( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                     NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TQ' ) ) THEN
*
*        TQ:  LQT routines for general matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKLQT( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                    NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'XQ' ) ) THEN
*
*        XQ:  LQT routines for triangular-pentagonal matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKLQTP( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                     NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'TS' ) ) THEN
*
*        TS:  QR routines for tall-skinny matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKTSQR( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                     NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 )PATH
         END IF
*
      ELSE IF( LSAMEN( 2, C2, 'HH' ) ) THEN
*
*        HH:  Householder reconstruction for tall-skinny matrices
*
         IF( TSTCHK ) THEN
            CALL DCHKORHR_COL( THRESH, TSTERR, NM, MVAL, NN, NVAL, NNB,
     $                         NBVAL, NOUT )
         ELSE
            WRITE( NOUT, FMT = 9989 ) PATH
         END IF
*
      ELSE

*
         WRITE( NOUT, FMT = 9990 )PATH
      END IF
*
*     Go back to get another input line.
*
      GO TO 80
*
*     Branch to this line when the last record is read.
*
  140 CONTINUE
      CLOSE ( NIN )
      S2 = DSECND( )
      WRITE( NOUT, FMT = 9998 )
      WRITE( NOUT, FMT = 9997 )S2 - S1
*
      DEALLOCATE (A, STAT = AllocateStatus)
      DEALLOCATE (B, STAT = AllocateStatus)
      DEALLOCATE (E, STAT = AllocateStatus)
      DEALLOCATE (S, STAT = AllocateStatus)
      DEALLOCATE (WORK, STAT = AllocateStatus)
      DEALLOCATE (RWORK,  STAT = AllocateStatus)
*
 9999 FORMAT( / ' Execution not attempted due to input errors' )
 9998 FORMAT( / ' End of tests' )
 9997 FORMAT( ' Total time used = ', F12.2, ' seconds', / )
 9996 FORMAT( ' Invalid input value: ', A4, '=', I6, '; must be >=',
     $      I6 )
 9995 FORMAT( ' Invalid input value: ', A4, '=', I6, '; must be <=',
     $      I6 )
 9994 FORMAT( ' Tests of the DOUBLE PRECISION LAPACK routines ',
     $      / ' LAPACK VERSION ', I1, '.', I2, '.', I1,
     $      / / ' The following parameter values will be used:' )
 9993 FORMAT( 4X, A4, ':  ', 10I6, / 11X, 10I6 )
 9992 FORMAT( / ' Routines pass computational tests if test ratio is ',
     $      'less than', F8.2, / )
 9991 FORMAT( ' Relative machine ', A, ' is taken to be', D16.6 )
 9990 FORMAT( / 1X, A3, ':  Unrecognized path name' )
 9989 FORMAT( / 1X, A3, ' routines were not tested' )
 9988 FORMAT( / 1X, A3, ' driver routines were not tested' )
*
*     End of DCHKAA
*
      END
