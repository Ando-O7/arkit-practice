//
//  ViewController.swift
//  arkit_marker
//
//  Created by Ando on 2019/11/09.
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
        
        // add light
        sceneView.autoenablesDefaultLighting = true;
        
        // get image recognition reference image from asset
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // create node
        let boxNode = SCNNode()
        
        // setting geometry and placement
        boxNode.geometry = SCNBox(width:0.05, height:0.05, length:0.05, chamferRadius: 0)
        boxNode.position.y += 0.025
        
        node.addChildNode(boxNode)
    }

}
