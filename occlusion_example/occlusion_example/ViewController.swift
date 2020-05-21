//
//  ViewController.swift
//  occlusion_example
//
//  Created by Ando on 2020/05/18.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // enable enviromnment mapping
        configuration.environmentTexturing = .automatic

        // check device support People Occlusion
        var message:String;
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            // use People Occlusion
            configuration.frameSemantics = .personSegmentationWithDepth
            message = "Yes, device supports people occulusion"
        } else {
            message = "No, device not supports poeple occulusion"
        }
        print("\(message)")

        // view text
        let depth:CGFloat = 0.2
        let text = SCNText(string: message, extrusionDepth: depth)
        text.font = UIFont.systemFont(ofSize: 1.0)

        // create text node and placement
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(-0.5, -1.5, -0.5)

        // add node
        sceneView.scene.rootNode.addChildNode(textNode)

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
