//
//  MatrixHelper.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 13/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//
import CoreLocation
import GLKit
import ARKit

private extension matrix_float4x4 {
    //     column 0  column 1  column 2  column 3
    //         1        0         0       X          x         x + X*w  
    //         0        1         0       Y      x   y    =    y + Y*w  
    //         0        0         1       Z          z         z + Z*w  
    //         0        0         0       1          w            w    
    func translatedMatrix(for translation : vector_float4) -> matrix_float4x4 {
        var matrix = self
        matrix.columns.3 = translation
        return matrix
    }

    //      column 0  column 1  column 2  column 3
    //        cosθ      0       sinθ        0    
    //         0        1        0          0     
    //       −sinθ      0       cosθ        0     
    //         0        0        0          1    
    func rotatedAroundY(for degrees: Float) -> matrix_float4x4 {
        var matrix : matrix_float4x4 = self

        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)

        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
}

extension matrix_float4x4 {
   var position: SCNVector3 {
        return SCNVector3Make(columns.3.x,
                              columns.3.y,
                              columns.3.z)
    }
}

extension simd_float4x4 {
    func transformMatrix(origin: CLLocation, destination: CLLocation) -> simd_float4x4 {
        let distance = Float(destination.distance(from: origin))
        let bearing = origin.bearing(to: destination)
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = matrix_identity_float4x4.translatedMatrix(for: position)
        let rotationMatrix = matrix_identity_float4x4.rotatedAroundY(for: Float(bearing))
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        return simd_mul(self, transformMatrix)
    }
}
