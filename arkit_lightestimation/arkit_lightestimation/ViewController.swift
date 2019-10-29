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
        
        // view feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // detection horizontal plane
        let configulation = ARWorldTrackingConfiguration()
        configulation.planeDetection = .horizontal
        sceneView.session.run(configulation)
    }
}
