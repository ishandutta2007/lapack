*> \brief \b DTPQRT
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> Download DTPQRT + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/dtpqrt.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/dtpqrt.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/dtpqrt.f">
*> [TXT]</a>
*
*  Definition:
*  ===========
*
*       SUBROUTINE DTPQRT( M, N, L, NB, A, LDA, B, LDB, T, LDT, WORK,
*                          INFO )
*
*       .. Scalar Arguments ..
*       INTEGER INFO, LDA, LDB, LDT, N, M, L, NB
*       ..
*       .. Array Arguments ..
*       DOUBLE PRECISION A( LDA, * ), B( LDB, * ), T( LDT, * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> DTPQRT computes a blocked QR factorization of a real
*> "triangular-pentagonal" matrix C, which is composed of a
*> triangular block A and pentagonal block B, using the compact
*> WY representation for Q.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix B.
*>          M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix B, and the order of the
*>          triangular matrix A.
*>          N >= 0.
*> \endverbatim
*>
*> \param[in] L
*> \verbatim
*>          L is INTEGER
*>          The number of rows of the upper trapezoidal part of B.
*>          MIN(M,N) >= L >= 0.  See Further Details.
*> \endverbatim
*>
*> \param[in] NB
*> \verbatim
*>          NB is INTEGER
*>          The block size to be used in the blocked QR.  N >= NB >= 1.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is DOUBLE PRECISION array, dimension (LDA,N)
*>          On entry, the upper triangular N-by-N matrix A.
*>          On exit, the elements on and above the diagonal of the array
*>          contain the upper triangular matrix R.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,N).
*> \endverbatim
*>
*> \param[in,out] B
*> \verbatim
*>          B is DOUBLE PRECISION array, dimension (LDB,N)
*>          On entry, the pentagonal M-by-N matrix B.  The first M-L rows
*>          are rectangular, and the last L rows are upper trapezoidal.
*>          On exit, B contains the pentagonal matrix V.  See Further Details.
*> \endverbatim
*>
*> \param[in] LDB
*> \verbatim
*>          LDB is INTEGER
*>          The leading dimension of the array B.  LDB >= max(1,M).
*> \endverbatim
*>
*> \param[out] T
*> \verbatim
*>          T is DOUBLE PRECISION array, dimension (LDT,N)
*>          The upper triangular block reflectors stored in compact form
*>          as a sequence of upper triangular blocks.  See Further Details.
*> \endverbatim
*>
*> \param[in] LDT
*> \verbatim
*>          LDT is INTEGER
*>          The leading dimension of the array T.  LDT >= NB.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is DOUBLE PRECISION array, dimension (NB*N)
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit
*>          < 0:  if INFO = -i, the i-th argument had an illegal value
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
*> \ingroup tpqrt
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The input matrix C is a (N+M)-by-N matrix
*>
*>               C = [ A ]
*>                   [ B ]
*>
*>  where A is an upper triangular N-by-N matrix, and B is M-by-N pentagonal
*>  matrix consisting of a (M-L)-by-N rectangular matrix B1 on top of a L-by-N
*>  upper trapezoidal matrix B2:
*>
*>               B = [ B1 ]  <- (M-L)-by-N rectangular
*>                   [ B2 ]  <-     L-by-N upper trapezoidal.
*>
*>  The upper trapezoidal matrix B2 consists of the first L rows of a
*>  N-by-N upper triangular matrix, where 0 <= L <= MIN(M,N).  If L=0,
*>  B is rectangular M-by-N; if M=L=N, B is upper triangular.
*>
*>  The matrix W stores the elementary reflectors H(i) in the i-th column
*>  below the diagonal (of A) in the (N+M)-by-N input matrix C
*>
*>               C = [ A ]  <- upper triangular N-by-N
*>                   [ B ]  <- M-by-N pentagonal
*>
*>  so that W can be represented as
*>
*>               W = [ I ]  <- identity, N-by-N
*>                   [ V ]  <- M-by-N, same form as B.
*>
*>  Thus, all of information needed for W is contained on exit in B, which
*>  we call V above.  Note that V has the same form as B; that is,
*>
*>               V = [ V1 ] <- (M-L)-by-N rectangular
*>                   [ V2 ] <-     L-by-N upper trapezoidal.
*>
*>  The columns of V represent the vectors which define the H(i)'s.
*>
*>  The number of blocks is B = ceiling(N/NB), where each
*>  block is of order NB except for the last block, which is of order
*>  IB = N - (B-1)*NB.  For each of the B blocks, a upper triangular block
*>  reflector factor is computed: T1, T2, ..., TB.  The NB-by-NB (and IB-by-IB
*>  for the last block) T's are stored in the NB-by-N matrix T as
*>
*>               T = [T1 T2 ... TB].
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE DTPQRT( M, N, L, NB, A, LDA, B, LDB, T, LDT, WORK,
     $                   INFO )
*
*  -- LAPACK computational routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
*     .. Scalar Arguments ..
      INTEGER INFO, LDA, LDB, LDT, N, M, L, NB
*     ..
*     .. Array Arguments ..
      DOUBLE PRECISION A( LDA, * ), B( LDB, * ), T( LDT, * ), WORK( * )
*     ..
*
* =====================================================================
*
*     ..
*     .. Local Scalars ..
      INTEGER    I, IB, LB, MB, IINFO
*     ..
*     .. External Subroutines ..
      EXTERNAL   DTPQRT2, DTPRFB, XERBLA
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.0 ) THEN
         INFO = -2
      ELSE IF( L.LT.0 .OR. (L.GT.MIN(M,N) .AND. MIN(M,N).GE.0)) THEN
         INFO = -3
      ELSE IF( NB.LT.1 .OR. (NB.GT.N .AND. N.GT.0)) THEN
         INFO = -4
      ELSE IF( LDA.LT.MAX( 1, N ) ) THEN
         INFO = -6
      ELSE IF( LDB.LT.MAX( 1, M ) ) THEN
         INFO = -8
      ELSE IF( LDT.LT.NB ) THEN
         INFO = -10
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'DTPQRT', -INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( M.EQ.0 .OR. N.EQ.0 ) RETURN
*
      DO I = 1, N, NB
*
*     Compute the QR factorization of the current block
*
         IB = MIN( N-I+1, NB )
         MB = MIN( M-L+I+IB-1, M )
         IF( I.GE.L ) THEN
            LB = 0
         ELSE
            LB = MB-M+L-I+1
         END IF
*
         CALL DTPQRT2( MB, IB, LB, A(I,I), LDA, B( 1, I ), LDB,
     $                 T(1, I ), LDT, IINFO )
*
*     Update by applying H**T to B(:,I+IB:N) from the left
*
         IF( I+IB.LE.N ) THEN
            CALL DTPRFB( 'L', 'T', 'F', 'C', MB, N-I-IB+1, IB, LB,
     $                    B( 1, I ), LDB, T( 1, I ), LDT,
     $                    A( I, I+IB ), LDA, B( 1, I+IB ), LDB,
     $                    WORK, IB )
         END IF
      END DO
      RETURN
*
*     End of DTPQRT
*
      END
