//
//  ViewController.swift
//  arkit_featurepoint
//
//  Created by Ando on 2019/10/08.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and register scene
        sceneView.scene = SCNScene()
        
        // view featurepoint
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // create config
        let configuration = ARWorldTrackingConfiguration()
        
        // start session
        sceneView.session.run(configuration)
    }
}
