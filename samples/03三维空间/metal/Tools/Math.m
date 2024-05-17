//
//  Math.m
//  metal
//
//  Created by Allen on 2022/11/1.
//

#import "Math.h"

simd_float4x4 translation_matrix(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {x, y, z, 1}
    };
}
simd_float4x4 scaling_matrix(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {x, 0, 0, 0},
        .columns[1] = {0, y, 0, 0},
        .columns[2] = {0, 0, z, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotation_x(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, cosTheta, sinTheta, 0},
        .columns[2] = {0, -sinTheta, cosTheta, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotation_y(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    simd_float4x4 rotationMatrix = {
        .columns[0] = {cosTheta, 0, -sinTheta, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {sinTheta, 0, cosTheta, 0},
        .columns[3] = {0, 0, 0, 1}
    };
    return rotationMatrix;
}
simd_float4x4 rotation_z(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    
    return (simd_float4x4){
        .columns[0] = {cosTheta, sinTheta, 0, 0},
        .columns[1] = {-sinTheta, cosTheta, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {0, 0, 0, 1}
    };
}
simd_float4x4 rotation_matrix(float angle_x, float angle_y, float angle_z) {
    simd_float4x4 rotationX = rotation_x(angle_x);
    simd_float4x4 rotationY = rotation_y(angle_y);
    simd_float4x4 rotationZ = rotation_z(angle_z);
   
    return matrix_multiply(matrix_multiply(rotationX, rotationY), rotationZ);
}
simd_float4x4 rotation_matrix_YXZ(float angle_x, float angle_y, float angle_z) {
    simd_float4x4 rotationX = rotation_x(angle_x);
    simd_float4x4 rotationY = rotation_y(angle_y);
    simd_float4x4 rotationZ = rotation_z(angle_z);
   
    return matrix_multiply(matrix_multiply(rotationY, rotationX), rotationZ);
}

simd_float4x4 identity(void) {
    return matrix_identity_float4x4;
}
simd_float3x3 getUpperLeft(simd_float4x4 matrix) {
    return (simd_float3x3){
        .columns[0] = {matrix.columns[0].x, matrix.columns[0].y, matrix.columns[0].z},
        .columns[1] = {matrix.columns[1].x, matrix.columns[1].y, matrix.columns[1].z},
        .columns[2] = {matrix.columns[2].x, matrix.columns[2].y, matrix.columns[2].z},
    };
}

simd_float4x4 projectionMatrix(float fov, float near, float far, float aspect) {
    float y = 1 / tan(fov * 0.5);
    float x = y / aspect;
    float z = far / (far - near);
    simd_float4x4 projectionMatrix = {
        .columns[0] = {x, 0, 0, 0},
        .columns[1] = {0, y, 0, 0},
        .columns[2] = {0, 0, z, 1},
        .columns[3] = {0, 0, z * -near, 0}
    };
    return projectionMatrix;
}



simd_float4x4 translationMatrix(float x, float y, float z) {
    return (simd_float4x4){
        .columns[0] = {1, 0, 0, 0},
        .columns[1] = {0, 1, 0, 0},
        .columns[2] = {0, 0, 1, 0},
        .columns[3] = {x, y, z, 1}
    };
}
simd_float4x4 inverseTranslationMatrix(float x, float y, float z) {
    simd_float4x4 translationMatrix = (simd_float4x4){
        .columns[0] = {1.0, 0.0, 0.0, 0.0},
        .columns[1] = {0.0, 1.0, 0.0, 0.0},
        .columns[2] = {0.0, 0.0, 1.0, 0.0},
        .columns[3] = {x, y, z, 1.0}
    };
    simd_float4x4 inverseMatrix = simd_inverse(translationMatrix);
    return inverseMatrix;
}
