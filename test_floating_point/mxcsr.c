// #include <xmmintrin.h>
// #include <stdio.h>
// #include <math.h>
// int main() {
//     unsigned int mxcsr;
//     float test_float_number = 2.3f;

//     _MM_SET_ROUNDING_MODE(_MM_ROUND_DOWN);
//     mxcsr = _mm_getcsr();
//     printf("MXCSR = 0x%08X\n", mxcsr);

//     float new_float_rounded = nearbyintf(test_float_number);
//     printf("Gia tri cua value float_num: %f",new_float_rounded);
//     return 0;
// }

//Nhan nhieu ma tran cung luc

#include <xmmintrin.h> // SSE
#include <pmmintrin.h>//SSE3
#include <stdio.h>
#include <stdlib.h> // For malloc and free
#include <time.h>   // For time measurement

// Original 2x2 matrix multiplication function (kept for reference)
void multiply2x2(const float* A, const float* B, float* C) {
    // A: [a11, a12, a21, a22]
    // B: [b11, b12, b21, b22]
    
    __m128 a1 = _mm_set_ps(A[0], A[1], A[0], A[1]); // [a11, a12, a11, a12]
    __m128 a2 = _mm_set_ps(A[2], A[3], A[2], A[3]); // [a21, a22, a21, a22]

    __m128 b_col1 = _mm_set_ps(B[2], B[0], B[2], B[0]); // b21, b11, b21, b11
    __m128 b_col2 = _mm_set_ps(B[3], B[1], B[3], B[1]); // b22, b12, b22, b12

    __m128 r1 = _mm_mul_ps(a1, b_col1);
    __m128 r2 = _mm_mul_ps(a2, b_col1);
    __m128 r3 = _mm_mul_ps(a1, b_col2);
    __m128 r4 = _mm_mul_ps(a2, b_col2);

    // horizontal add
    __m128 row0 = _mm_hadd_ps(r1, r3); // [c11, c11, c12, c12]
    __m128 row1 = _mm_hadd_ps(r2, r4); // [c21, c21, c22, c22]

    // Shuffle to get final result [c11, c12, c21, c22]
    __m128 result = _mm_shuffle_ps(row0, row1, _MM_SHUFFLE(2, 0, 2, 0));

    // Store the result
    _mm_storeu_ps(C, result);
}

void transposeMatrix(const float* B, float* B_T, int N) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            B_T[j * N + i] = B[i * N + j];
        }
    }
}

// Function for general matrix multiplication using SSE and transposed B
void multiplyMatrices(const float* A, const float* B_T, float* C, int N) {
    for (int i = 0; i < N; i++) { // rows of C
        for (int j = 0; j < N; j++) { // columns of C
            __m128 sum = _mm_setzero_ps(); // Accumulator for C[i][j]
            for (int k = 0; k < N; k += 4) { // inner product, process 4 elements at a time
                __m128 a_vec = _mm_loadu_ps(&A[i * N + k]);
                __m128 b_t_vec = _mm_loadu_ps(&B_T[j * N + k]);
                sum = _mm_add_ps(sum, _mm_mul_ps(a_vec, b_t_vec));
            }
            // Horizontally sum the elements in 'sum' and store in C[i][j]
            sum = _mm_hadd_ps(sum, sum);
            sum = _mm_hadd_ps(sum, sum);
            _mm_store_ss(&C[i * N + j], sum); // Store the lowest element
        }
    }
}

int main() {
    int N = 5000;
    float *A, *B, *C, *B_T;
    clock_t start_time, end_time;
    double elapsed_time;

    // Allocate memory for matrices
    A = (float*)malloc(N * N * sizeof(float));
    B = (float*)malloc(N * N * sizeof(float));
    C = (float*)malloc(N * N * sizeof(float));
    B_T = (float*)malloc(N * N * sizeof(float));

    if (A == NULL || B == NULL || C == NULL || B_T == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    // Initialize matrices A and B (e.g., with 1.0)
    for (int i = 0; i < N * N; i++) {
        A[i] = 1.0;
        B[i] = 1.0;
    }

    // Transpose matrix B
    transposeMatrix(B, B_T, N);

    // Perform matrix multiplication and measure time
    start_time = clock();
    multiplyMatrices(A, B_T, C, N); // Use B_T here
    end_time = clock();

    // Calculate and print elapsed time
    elapsed_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    printf("Matrix multiplication of %dx%d matrices took %.2f seconds\n", N, N, elapsed_time);

    // Free allocated memory
    free(A);
    free(B);
    free(C);
    free(B_T);

    return 0;
}
