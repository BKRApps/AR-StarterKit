//
//  PlacingObjectsViewController.swift
//  AR-SwiftMeetup
//
//  Created by Birapuram Kumar Reddy on 11/30/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlacingObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = SCNScene()
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        //add tap gesture, whenever a user tap on the screen, render a random node and place it
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlacingObjectsViewController.handleTap(tapGesture:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            //6DOF, enables plane detection, scene understanding
            if ARWorldTrackingConfiguration.isSupported {
                let configuration = ARWorldTrackingConfiguration()
                sceneView.session.run(configuration, options: [])
            }else{
                let configuration = AROrientationTrackingConfiguration()
                sceneView.session.run(configuration, options: [])
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }


    @objc func handleTap(tapGesture:UITapGestureRecognizer){
        let tappedPoint = tapGesture.location(in: sceneView)
        print("tapped on the location \(tappedPoint)")
        let node = SCNNode.getRandomNode()
        //placing the node
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        let finalTransform = simd_mul(cameraTransform!, translation)
        node.transform = SCNMatrix4(finalTransform)


        sceneView.scene.rootNode.addChildNode(node)
    }

}

extension PlacingObjectsViewController {
    static func getViewController() -> PlacingObjectsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "placingObjectsVC") as! PlacingObjectsViewController
        return viewController
    }
}
