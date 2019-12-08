//
//  ViewController.swift
//  arkit_lazer
//
//  Created by Ando on 2019/12/05.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var label: UILabel!
    var centerPos = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create scene
        sceneView.scene = SCNScene()
        
        // save center coordinate
        centerPos = sceneView.center
        
        // start session
        let configularion = ARWorldTrackingConfiguration()
        sceneView.session.run(configularion)
    }
    
    // call function per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // hit judgment feature point and screen center
        let hitResults = sceneView.hitTest(centerPos, types: [.featurePoint])
        
        if !hitResults.isEmpty {
            if let hitResult = hitResults.first {
                let distance = hitResult.distance
                
                // view distance
                DispatchQueue.main.async {
                    self.label.text = String(format: "%.1f", distance*100) + " cm"
                }
            }
        }
    }
}
