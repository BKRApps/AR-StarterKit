//
//  PlaneDetectionViewController.swift
//  AR-SwiftMeetup
//
//  Created by Birapuram Kumar Reddy on 11/30/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class PlaneDetectionViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var existingPlanes:[String:SCNNode] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = SCNScene()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlaneDetectionViewController.handleTap(tapGesture:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *){
            if ARWorldTrackingConfiguration.isSupported {
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                sceneView.session.run(configuration, options: [])
            }else{
                print("This device does not support plane detection.")
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc func handleTap(tapGesture:UITapGestureRecognizer) {
        let point = tapGesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(point, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let hitResult = hitResults.first
            let transform = hitResult?.worldTransform
            let node = SCNNode.getRandomNode()
            node.transform = SCNMatrix4(transform!)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
}

extension PlaneDetectionViewController : ARSCNViewDelegate {
    /**
     Called when a new node has been mapped to the given anchor.

     @param renderer The renderer that will render the scene.
     @param node The node that maps to the anchor.
     @param anchor The added anchor.
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let geometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: 0.005, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
            geometry.firstMaterial?.diffuse.contents = UIColor.init(red: 0, green: 0, blue: 1, alpha: 0.5)
            let planeNode = SCNNode(geometry: geometry)
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: -0.005, z: planeAnchor.center.z)
            existingPlanes[planeAnchor.identifier.uuidString] = planeNode
            node.addChildNode(planeNode)
        }
    }

    /**
     Called when a node has been updated with data from the given anchor.

     @param renderer The renderer that will render the scene.
     @param node The node that was updated.
     @param anchor The anchor that was updated.
     */
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if let existingNode = existingPlanes[planeAnchor.identifier.uuidString] {
                let box = existingNode.geometry as! SCNBox
                //update the width & height of the geometry
                box.width = CGFloat(planeAnchor.extent.x)
                box.height = CGFloat(planeAnchor.extent.z)
                //update the position
                existingNode.position = SCNVector3(x: planeAnchor.center.x, y: -0.005, z: planeAnchor.center.z)
            }
        }
    }

    /**
     Called when a mapped node has been removed from the scene graph for the given anchor.

     @param renderer The renderer that will render the scene.
     @param node The node that was removed.
     @param anchor The anchor that was removed.
     */

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            existingPlanes.removeValue(forKey: planeAnchor.identifier.uuidString)
        }
    }
}

extension PlaneDetectionViewController {
    static func getViewController() -> PlaneDetectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "planeDetectionVC") as! PlaneDetectionViewController
        return viewController
    }
}

