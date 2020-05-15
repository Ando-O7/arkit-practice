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
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError("Not supported")}

        // Set the view's delegate
        sceneView.delegate = self

        // create scene
        sceneView.scene = SCNScene()

        let configration = ARFaceTrackingConfiguration()

        sceneView.session.run(configration)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let faceGeometry = faceAnchor.geometry
    }
}
