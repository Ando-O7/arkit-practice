//
//  ViewController.swift
//  arkit_measure
//
//  Created by Ando on 2019/12/09.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var centerPos = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // create scene
        sceneView.scene = SCNScene()

        // save center position
        centerPos = sceneView.center

        // start session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    private func putSphere(at pos: SIMD3<Float>) {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.003)
        node.position = SCNVector3(pos.x, pos.y, pos.z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}
