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
    
    private var faceGeometry: ARSCNFaceGeometry!
    private var faceNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError("Not supported")}

        guard let device = sceneView.device else { return }
        faceGeometry = ARSCNFaceGeometry(device: device)
        if let material = faceGeometry.firstMaterial {
            material.diffuse.contents = UIColor.lightGray
            material.lightingModel = .physicallyBased
        }

        faceNode = SCNNode(geometry: faceGeometry)

        // Set the view's delegate
        sceneView.delegate = self

        // create scene
        sceneView.scene = SCNScene()

        let configration = ARFaceTrackingConfiguration()

        sceneView.session.run(configration)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        faceGeometry.update(from: faceAnchor.geometry)
        node.addChildNode(faceNode)
    }
}
