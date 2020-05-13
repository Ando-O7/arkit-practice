//
//  ViewController.swift
//  arkit_facetracking
//
//  Created by Ando on 2020/05/12.
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
        
    }
}
