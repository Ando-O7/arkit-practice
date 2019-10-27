//
//  ViewController.swift
//  arkit_model3d
//
//  Created by Ando on 2019/10/25.
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
        let configlation = ARWorldTrackingConfiguration()
        configlation.planeDetection = .horizontal
        sceneView.session.run(configlation)
    }
    
    // when detection it call
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // read scene from scn file
        let scene = SCNScene(named: "art.scnassets/Handgun_dae.scn")
        
        // search node from scene
        let handgunNode = (scene?.rootNode.childNode(withName: "handgun", recursively: false))!
        
        // child node
        node.addChildNode(handgunNode)
    }
}
