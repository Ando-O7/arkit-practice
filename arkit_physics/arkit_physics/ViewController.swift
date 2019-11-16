//
//  ViewController.swift
//  arkit_physics
//
//  Created by Ando on 2019/11/15.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create and register scene
        sceneView.scene = SCNScene()
        
        // view feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // add light
        sceneView.autoenablesDefaultLighting = true;
        
        // detection plan
        let configulation = ARWorldTrackingConfiguration()
        configulation.planeDetection = .horizontal
        sceneView.session.run(configulation)
    }
    
    // add sphere
    func addSphere(hitResult: ARHitTestResult) {
        // create node
        let sphereNode = SCNNode()
        
        // setting Geometry and Transform
        let sphereGometry = SCNSphere(radius: 0.03)
        sphereNode.geometry = sphereGometry
        sphereNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.05, hitResult.worldTransform.columns.3.z)
        
        // add node
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        // create Node
        let planeNode = SCNNode()
        
        // create geometry
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        geometry.materials.first?.diffuse.contents = UIColor.black.withAlphaComponent(0.5)
        
        // setting geometry and transform
        planeNode.geometry = geometry
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        node.addChildNode(planeNode)
    }

}
