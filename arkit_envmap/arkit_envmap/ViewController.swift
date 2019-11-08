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
        
        // create and register scene
        sceneView.scene = SCNScene()
        
        // when using an existing environment map
        let env = UIImage(named:"art.scnassets/envmap.jpg")
        self.sceneView.scene.lightingEnvironment.contents = env;
        
        // view feature points for debug
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // detection horizontal plane
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // automatic create env map
        configuration.environmentTexturing = .automatic
        
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // load scene from scn file
        let scene = SCNScene(named: "art.scnassets/bot1.scn")
        
        // search node from scene
        let botNode = (scene?.rootNode.childNode(withName: "bot1", recursively: false))!
        
        // make it a child element of the detection surface
        node.addChildNode(botNode)
    }
}
