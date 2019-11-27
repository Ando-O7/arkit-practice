//
//  ViewController.swift
//  arkit_share
//
//  Created by Ando on 2019/11/27.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let colorTable = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.white, UIColor.black]
    var myColorIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting color
        myColorIdx = Int(arc4random_uniform(UInt32(colorTable.count)))
        
        // Set the view's delegate
        sceneView.delegate = self
    }
}
