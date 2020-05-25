//
//  ViewController.swift
//  space_drawing
//
//  Created by Ando on 2020/05/25.
//  Copyright © 2020 AND. All rights reserved.
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
        
        // set debug option(feature points)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        // set scene
        sceneView.scene = SCNScene()
        
        // create configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // start session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
