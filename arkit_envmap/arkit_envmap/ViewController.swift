//
//  ViewController.swift
//  arkit_envmap
//
//  Created by Ando on 2019/11/03.
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
        
        
        
        
        let configuration = ARWorldTrackingConfiguration()
        
    }
}