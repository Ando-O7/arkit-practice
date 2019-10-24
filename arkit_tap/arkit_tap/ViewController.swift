//
//  ViewController.swift
//  arkit_tap
//
//  Created by Ando on 2019/10/18.
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
        sceneView.autoenablesDefaultLighting = true
        
        // detection horizontal plane
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    // touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get of first tap coordinate
        guard let touch = touches.first else {return}
        
        // transtrate screen coordinate
        let touchPos = touch.location(in: sceneView)
        
        // find AR anchor at tapped position
        let hitTest = sceneView.hitTest(touchPos, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            // add anchor if tapped location is available
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    // detection
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else { return }
        
        // create sphere node
        let sphereNode = SCNNode()
        
        // set Geometry and Transform at node
        sphereNode.geometry = SCNSphere(radius: 0.05)
        sphereNode.position.y += Float(0.05)
        
        node.addChildNode(sphereNode)
    }

}
