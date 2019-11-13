//
//  ViewController.swift
//  arkit_shape
//
//  Created by Ando on 2019/11/13.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private let device = MTLCreateSystemDefaultDevice()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create and register scene
        sceneView.scene = SCNScene()
        
        // view feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // detection horizontal plane
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        // create plannar geometry
        let planeGeometry = ARSCNPlaneGeometry(device: device)!
        planeGeometry.update(from: planeAnchor.geometry)
        planeGeometry.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        
        // create plane node
        let planeNode = SCNNode()
        planeNode.geometry = planeGeometry
        
        // add node
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        guard let planeGeometry = node.childNodes.first!.geometry as? ARSCNPlaneGeometry else {return}
        
        // update plane geometry
        planeGeometry.update(from: planeAnchor.geometry)
    }

}
