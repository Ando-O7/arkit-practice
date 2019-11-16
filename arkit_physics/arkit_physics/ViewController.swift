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

}
