//
//  Extentions.swift
//  AR-SwiftMeetup
//
//  Created by Birapuram Kumar Reddy on 11/30/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import SceneKit

extension SCNGeometry {
    static internal func getRandomGeometry() -> SCNGeometry {
        let random = arc4random_uniform(4)
        var geometry:SCNGeometry
        switch random {
        case 0:
            geometry = SCNPlane(width: 0.04, height: 0.04)
        case 1:
            geometry = SCNBox(width: 0.04, height: 0.03, length: 0.04, chamferRadius: 1.0)
        case 2:
            geometry = SCNSphere(radius: 0.02)
        case 3:
            geometry = SCNPyramid(width: 0.04, height: 0.04, length: 0.01)
        default:
            geometry = SCNBox(width: 0.04, height: 0.04, length: 0.04, chamferRadius: 1.0)
        }
        // we can diffuse either color or images
        geometry.firstMaterial?.diffuse.contents = UIColor.randomColor()
        return geometry
    }
}

extension SCNNode {
    static internal func getRandomNode() -> SCNNode {
        let geometry = SCNGeometry.getRandomGeometry()
        let node = SCNNode(geometry: geometry)
        return node
    }
}

extension matrix_float4x4 {
    func printMatrix()  {
        print(" Matrix ")
        print("[ \(columns.0.x)  \(columns.1.x)  \(columns.2.x) \(columns.3.x) ]")
        print("[ \(columns.0.y)  \(columns.1.y)  \(columns.2.y) \(columns.3.y) ]")
        print("[ \(columns.0.z)  \(columns.1.z)  \(columns.2.z) \(columns.3.z) ]")
        print("[ \(columns.0.w) \(columns.1.w) \(columns.2.w) \(columns.3.w) ] \n\n")
    }
}


extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
    }
}




