//
//  ViewController.swift
//  arkit_lightestimation
//
//  Created by Ando on 2019/10/28.
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
        var omniLight: SCNLight!
        
        // view feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // add Omni light
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = .omni
        omniLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        omniLightNode.light!.color = UIColor.white
        self.sceneView.scene.rootNode.addChildNode(omniLightNode)
        
        // save member variables
        omniLight = omniLightNode.light
        
        // detection horizontal plane
        let configulation = ARWorldTrackingConfiguration()
        configulation.planeDetection = .horizontal
        
        // enable light source estimation
        configulation.isLightEstimationEnabled = true;
        
        sceneView.session.run(configulation)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // load scene from scn file
        let scene = SCNScene(named: "art.scnassets/ship.scn")
        
        // search node from scene
        let shipNode = (scene?.rootNode.childNode(withName: "ship", recursively: false))!
        
        node.addChildNode(shipNode)
    }
}
