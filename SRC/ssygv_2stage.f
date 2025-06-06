*> \brief \b SSYGV_2STAGE
*
*  @generated from dsygv_2stage.f, fortran d -> s, Sun Nov  6 12:54:29 2016
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> Download SSYGV_2STAGE + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/ssygv_2stage.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/ssygv_2stage.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/ssygv_2stage.f">
*> [TXT]</a>
*
*  Definition:
*  ===========
*
*       SUBROUTINE SSYGV_2STAGE( ITYPE, JOBZ, UPLO, N, A, LDA, B, LDB, W,
*                                WORK, LWORK, INFO )
*
*       IMPLICIT NONE
*
*       .. Scalar Arguments ..
*       CHARACTER          JOBZ, UPLO
*       INTEGER            INFO, ITYPE, LDA, LDB, LWORK, N
*       ..
*       .. Array Arguments ..
*       REAL               A( LDA, * ), B( LDB, * ), W( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SSYGV_2STAGE computes all the eigenvalues, and optionally, the eigenvectors
*> of a real generalized symmetric-definite eigenproblem, of the form
*> A*x=(lambda)*B*x,  A*Bx=(lambda)*x,  or B*A*x=(lambda)*x.
*> Here A and B are assumed to be symmetric and B is also
*> positive definite.
*> This routine use the 2stage technique for the reduction to tridiagonal
*> which showed higher performance on recent architecture and for large
*> sizes N>2000.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] ITYPE
*> \verbatim
*>          ITYPE is INTEGER
*>          Specifies the problem type to be solved:
*>          = 1:  A*x = (lambda)*B*x
*>          = 2:  A*B*x = (lambda)*x
*>          = 3:  B*A*x = (lambda)*x
*> \endverbatim
*>
*> \param[in] JOBZ
*> \verbatim
*>          JOBZ is CHARACTER*1
*>          = 'N':  Compute eigenvalues only;
*>          = 'V':  Compute eigenvalues and eigenvectors.
*>                  Not available in this release.
*> \endverbatim
*>
*> \param[in] UPLO
*> \verbatim
*>          UPLO is CHARACTER*1
*>          = 'U':  Upper triangles of A and B are stored;
*>          = 'L':  Lower triangles of A and B are stored.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The order of the matrices A and B.  N >= 0.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is REAL array, dimension (LDA, N)
*>          On entry, the symmetric matrix A.  If UPLO = 'U', the
*>          leading N-by-N upper triangular part of A contains the
*>          upper triangular part of the matrix A.  If UPLO = 'L',
*>          the leading N-by-N lower triangular part of A contains
*>          the lower triangular part of the matrix A.
*>
*>          On exit, if JOBZ = 'V', then if INFO = 0, A contains the
*>          matrix Z of eigenvectors.  The eigenvectors are normalized
*>          as follows:
*>          if ITYPE = 1 or 2, Z**T*B*Z = I;
*>          if ITYPE = 3, Z**T*inv(B)*Z = I.
*>          If JOBZ = 'N', then on exit the upper triangle (if UPLO='U')
*>          or the lower triangle (if UPLO='L') of A, including the
*>          diagonal, is destroyed.
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
*>          B is REAL array, dimension (LDB, N)
*>          On entry, the symmetric positive definite matrix B.
*>          If UPLO = 'U', the leading N-by-N upper triangular part of B
*>          contains the upper triangular part of the matrix B.
*>          If UPLO = 'L', the leading N-by-N lower triangular part of B
*>          contains the lower triangular part of the matrix B.
*>
*>          On exit, if INFO <= N, the part of B containing the matrix is
*>          overwritten by the triangular factor U or L from the Cholesky
*>          factorization B = U**T*U or B = L*L**T.
*> \endverbatim
*>
*> \param[in] LDB
*> \verbatim
*>          LDB is INTEGER
*>          The leading dimension of the array B.  LDB >= max(1,N).
*> \endverbatim
*>
*> \param[out] W
*> \verbatim
*>          W is REAL array, dimension (N)
*>          If INFO = 0, the eigenvalues in ascending order.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is REAL array, dimension (MAX(1,LWORK))
*>          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          The length of the array WORK. LWORK >= 1, when N <= 1;
*>          otherwise
*>          If JOBZ = 'N' and N > 1, LWORK must be queried.
*>                                   LWORK = MAX(1, dimension) where
*>                                   dimension = max(stage1,stage2) + (KD+1)*N + 2*N
*>                                             = N*KD + N*max(KD+1,FACTOPTNB)
*>                                               + max(2*KD*KD, KD*NTHREADS)
*>                                               + (KD+1)*N + 2*N
*>                                   where KD is the blocking size of the reduction,
*>                                   FACTOPTNB is the blocking used by the QR or LQ
*>                                   algorithm, usually FACTOPTNB=128 is a good choice
*>                                   NTHREADS is the number of threads used when
*>                                   openMP compilation is enabled, otherwise =1.
*>          If JOBZ = 'V' and N > 1, LWORK must be queried. Not yet available
*>
*>          If LWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the WORK array, returns
*>          this value as the first entry of the WORK array, and no error
*>          message related to LWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit
*>          < 0:  if INFO = -i, the i-th argument had an illegal value
*>          > 0:  SPOTRF or SSYEV returned an error code:
*>             <= N:  if INFO = i, SSYEV failed to converge;
*>                    i off-diagonal elements of an intermediate
*>                    tridiagonal form did not converge to zero;
*>             > N:   if INFO = N + i, for 1 <= i <= N, then the leading
*>                    principal minor of order i of B is not positive.
*>                    The factorization of B could not be completed and
*>                    no eigenvalues or eigenvectors were computed.
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
*> \ingroup hegv_2stage
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  All details about the 2stage techniques are available in:
*>
*>  Azzam Haidar, Hatem Ltaief, and Jack Dongarra.
*>  Parallel reduction to condensed forms for symmetric eigenvalue problems
*>  using aggregated fine-grained and memory-aware kernels. In Proceedings
*>  of 2011 International Conference for High Performance Computing,
*>  Networking, Storage and Analysis (SC '11), New York, NY, USA,
*>  Article 8 , 11 pages.
*>  http://doi.acm.org/10.1145/2063384.2063394
*>
*>  A. Haidar, J. Kurzak, P. Luszczek, 2013.
*>  An improved parallel singular value algorithm and its implementation
*>  for multicore hardware, In Proceedings of 2013 International Conference
*>  for High Performance Computing, Networking, Storage and Analysis (SC '13).
*>  Denver, Colorado, USA, 2013.
*>  Article 90, 12 pages.
*>  http://doi.acm.org/10.1145/2503210.2503292
*>
*>  A. Haidar, R. Solca, S. Tomov, T. Schulthess and J. Dongarra.
*>  A novel hybrid CPU-GPU generalized eigensolver for electronic structure
*>  calculations based on fine-grained memory aware tasks.
*>  International Journal of High Performance Computing Applications.
*>  Volume 28 Issue 2, Pages 196-209, May 2014.
*>  http://hpc.sagepub.com/content/28/2/196
*>
*> \endverbatim
*
*  =====================================================================
      SUBROUTINE SSYGV_2STAGE( ITYPE, JOBZ, UPLO, N, A, LDA, B, LDB,
     $                         W,
     $                         WORK, LWORK, INFO )
*
      IMPLICIT NONE
*
*  -- LAPACK driver routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
*     .. Scalar Arguments ..
      CHARACTER          JOBZ, UPLO
      INTEGER            INFO, ITYPE, LDA, LDB, LWORK, N
*     ..
*     .. Array Arguments ..
      REAL               A( LDA, * ), B( LDB, * ), W( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE
      PARAMETER          ( ONE = 1.0E+0 )
*     ..
*     .. Local Scalars ..
      LOGICAL            LQUERY, UPPER, WANTZ
      CHARACTER          TRANS
      INTEGER            NEIG, LWMIN, LHTRD, LWTRD, KD, IB
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      INTEGER            ILAENV2STAGE
      REAL               SROUNDUP_LWORK
      EXTERNAL           LSAME, ILAENV2STAGE, SROUNDUP_LWORK
*     ..
*     .. External Subroutines ..
      EXTERNAL           SPOTRF, SSYGST, STRMM, STRSM,
     $                   XERBLA,
     $                   SSYEV_2STAGE
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. Executable Statements ..
*
*     Test the input parameters.
*
      WANTZ = LSAME( JOBZ, 'V' )
      UPPER = LSAME( UPLO, 'U' )
      LQUERY = ( LWORK.EQ.-1 )
*
      INFO = 0
      IF( ITYPE.LT.1 .OR. ITYPE.GT.3 ) THEN
         INFO = -1
      ELSE IF( .NOT.( LSAME( JOBZ, 'N' ) ) ) THEN
         INFO = -2
      ELSE IF( .NOT.( UPPER .OR. LSAME( UPLO, 'L' ) ) ) THEN
         INFO = -3
      ELSE IF( N.LT.0 ) THEN
         INFO = -4
      ELSE IF( LDA.LT.MAX( 1, N ) ) THEN
         INFO = -6
      ELSE IF( LDB.LT.MAX( 1, N ) ) THEN
         INFO = -8
      END IF
*
      IF( INFO.EQ.0 ) THEN
         KD    = ILAENV2STAGE( 1, 'SSYTRD_2STAGE', JOBZ, N, -1, -1,
     $                         -1 )
         IB    = ILAENV2STAGE( 2, 'SSYTRD_2STAGE', JOBZ, N, KD, -1,
     $                         -1 )
         LHTRD = ILAENV2STAGE( 3, 'SSYTRD_2STAGE', JOBZ, N, KD, IB,
     $                         -1 )
         LWTRD = ILAENV2STAGE( 4, 'SSYTRD_2STAGE', JOBZ, N, KD, IB,
     $                         -1 )
         LWMIN = 2*N + LHTRD + LWTRD
         WORK( 1 )  = REAL( LWMIN )
*
         IF( LWORK.LT.LWMIN .AND. .NOT.LQUERY ) THEN
            INFO = -11
         END IF
      END IF
*
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'SSYGV_2STAGE ', -INFO )
         RETURN
      ELSE IF( LQUERY ) THEN
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( N.EQ.0 )
     $   RETURN
*
*     Form a Cholesky factorization of B.
*
      CALL SPOTRF( UPLO, N, B, LDB, INFO )
      IF( INFO.NE.0 ) THEN
         INFO = N + INFO
         RETURN
      END IF
*
*     Transform problem to standard eigenvalue problem and solve.
*
      CALL SSYGST( ITYPE, UPLO, N, A, LDA, B, LDB, INFO )
      CALL SSYEV_2STAGE( JOBZ, UPLO, N, A, LDA, W, WORK, LWORK,
     $                   INFO )
*
      IF( WANTZ ) THEN
*
*        Backtransform eigenvectors to the original problem.
*
         NEIG = N
         IF( INFO.GT.0 )
     $      NEIG = INFO - 1
         IF( ITYPE.EQ.1 .OR. ITYPE.EQ.2 ) THEN
*
*           For A*x=(lambda)*B*x and A*B*x=(lambda)*x;
*           backtransform eigenvectors: x = inv(L)**T*y or inv(U)*y
*
            IF( UPPER ) THEN
               TRANS = 'N'
            ELSE
               TRANS = 'T'
            END IF
*
            CALL STRSM( 'Left', UPLO, TRANS, 'Non-unit', N, NEIG,
     $                  ONE,
     $                  B, LDB, A, LDA )
*
         ELSE IF( ITYPE.EQ.3 ) THEN
*
*           For B*A*x=(lambda)*x;
*           backtransform eigenvectors: x = L*y or U**T*y
*
            IF( UPPER ) THEN
               TRANS = 'T'
            ELSE
               TRANS = 'N'
            END IF
*
            CALL STRMM( 'Left', UPLO, TRANS, 'Non-unit', N, NEIG,
     $                  ONE,
     $                  B, LDB, A, LDA )
         END IF
      END IF
*
      WORK( 1 ) = SROUNDUP_LWORK(LWMIN)
      RETURN
*
*     End of SSYGV_2STAGE
*
      END
