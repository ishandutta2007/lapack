/*
 * cblas_chemv.c
 * The program is a C interface to chemv
 *
 * Keita Teranishi  5/18/98
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cblas.h"
#include "cblas_f77.h"
void API_SUFFIX(cblas_chemv)(const CBLAS_LAYOUT layout,
                 const CBLAS_UPLO Uplo, const CBLAS_INT N,
                 const void *alpha, const void *A, const CBLAS_INT lda,
                 const void *X, const CBLAS_INT incX, const void *beta,
                 void  *Y, const CBLAS_INT incY)
{
   char UL;
#ifdef F77_CHAR
   F77_CHAR F77_UL;
#else
   #define F77_UL &UL
#endif
#ifdef F77_INT
   F77_INT F77_N=N, F77_lda=lda, F77_incX=incX, F77_incY=incY;
#else
   CBLAS_INT incx = incX;
   #define F77_N N
   #define F77_lda lda
   #define F77_incX incx
   #define F77_incY incY
#endif
   CBLAS_INT n=0, i=0;
   const float *xx= (const float *)X, *alp= (const float *)alpha, *bet = (const float *)beta;
   float ALPHA[2],BETA[2];
   CBLAS_INT tincY, tincx;
   float *x, *y, *st=0, *tx;
   extern int CBLAS_CallFromC;
   extern int RowMajorStrg;
   RowMajorStrg = 0;

   memcpy(&x, &X, sizeof(float*));
   memcpy(&y, &Y, sizeof(float*));


   CBLAS_CallFromC = 1;
   if (layout == CblasColMajor)
   {
      if (Uplo == CblasUpper) UL = 'U';
      else if (Uplo == CblasLower) UL = 'L';
      else
      {
         API_SUFFIX(cblas_xerbla)(2, "cblas_chemv","Illegal Uplo setting, %d\n",Uplo );
         CBLAS_CallFromC = 0;
         RowMajorStrg = 0;
         return;
      }
      #ifdef F77_CHAR
         F77_UL = C2F_CHAR(&UL);
      #endif
      F77_chemv(F77_UL, &F77_N, alpha, A, &F77_lda, X, &F77_incX,
                beta, Y, &F77_incY);
   }
   else if (layout == CblasRowMajor)
   {
      RowMajorStrg = 1;
      ALPHA[0]= *alp;
      ALPHA[1]= -alp[1];
      BETA[0]= *bet;
      BETA[1]= -bet[1];

      if (N > 0)
      {
         n = N << 1;
         x = malloc(n*sizeof(float));

         tx = x;
         if( incX > 0 ) {
           i = incX << 1 ;
           tincx = 2;
           st= x+n;
         } else {
           i = incX *(-2);
           tincx = -2;
           st = x-2;
           x +=(n-2);
         }

         do
         {
           *x = *xx;
           x[1] = -xx[1];
           x += tincx ;
           xx += i;
         }
         while (x != st);
         x=tx;


         #ifdef F77_INT
            F77_incX = 1;
         #else
            incx = 1;
         #endif

         if(incY > 0)
           tincY = incY;
         else
           tincY = -incY;
         y++;

         i = tincY << 1;
         n = i * N ;
         st = y + n;
         do {
            *y = -(*y);
            y += i;
         } while(y != st);
         y -= n;
      }  else
         memcpy(&x, &X, sizeof(float*));


      if (Uplo == CblasUpper) UL = 'L';
      else if (Uplo == CblasLower) UL = 'U';
      else
      {
         API_SUFFIX(cblas_xerbla)(2, "cblas_chemv","Illegal Uplo setting, %d\n", Uplo);
         CBLAS_CallFromC = 0;
         RowMajorStrg = 0;
         return;
      }
      #ifdef F77_CHAR
         F77_UL = C2F_CHAR(&UL);
      #endif
      F77_chemv(F77_UL, &F77_N, ALPHA, A, &F77_lda, x, &F77_incX,
                BETA, Y, &F77_incY);
   }
   else
   {
      API_SUFFIX(cblas_xerbla)(1, "cblas_chemv","Illegal layout setting, %d\n", layout);
      CBLAS_CallFromC = 0;
      RowMajorStrg = 0;
      return;
   }
   if ( layout == CblasRowMajor )
   {
      RowMajorStrg = 1;
      if ( X != x )
         free(x);
      if (N > 0)
      {
         do
         {
            *y = -(*y);
            y += i;
         }
         while (y != st);
     }
   }
   CBLAS_CallFromC = 0;
   RowMajorStrg = 0;
   return;
}
