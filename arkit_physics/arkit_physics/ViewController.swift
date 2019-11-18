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
        
        // behavior setting of PhysicsBody
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:nil)
        
        // setting of PhysicsBody parameter
        sphereNode.physicsBody?.mass = 1.0
        sphereNode.physicsBody?.friction = 1.5
        sphereNode.physicsBody?.rollingFriction = 1.0
        sphereNode.physicsBody?.damping = 0.5
        sphereNode.physicsBody?.angularDamping = 0.5
        sphereNode.physicsBody?.isAffectedByGravity = true
        
        // apply upward force
        sphereNode.physicsBody?.applyForce(SCNVector3(0, 1.5, 0), asImpulse: true)
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        guard let geometryPlaneNode = node.childNodes.first,
            let planeGeometry = geometryPlaneNode.geometry as? SCNPlane else {fatalError()}
        
        // update Geometry
        planeGeometry.width = CGFloat(planeAnchor.extent.x)
        planeGeometry.height = CGFloat(planeAnchor.extent.z)
        geometryPlaneNode.simdPosition = SIMD3(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get first touch coordinate
        guard let touch = touches.first else {return}
        
        // conversion coordinate of screen
        let touchPos = touch.location(in: sceneView)
        
        // hit detection with detected plane
        let hitTestResult = sceneView.hitTest(touchPos, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            if let hitResult = hitTestResult.first {
                // add a sphere if it touches the plane
                addSphere(hitResult: hitResult)
            }
        }
    }

}
