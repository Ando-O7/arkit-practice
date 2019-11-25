//
//  ViewController.swift
//  arkit_persistence
//
//  Created by Ando on 2019/11/19.
//  Copyright © 2019 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("WorldMapURL")
        } catch {
            fatalError("No such file")
        }
    }()
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // get current ARWorldMap
        sceneView.session.getCurrentWorldMap { ARWorldMap, error in
            guard let map = ARWorldMap else {return}
            
            // serialize
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) else { return }
            
            // save local
            guard ((try? data.write(to: self.worldMapURL)) != nil) else { return }
        }
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        // load of save ARWorldMap
        var data: Data? = nil
        do {
            try data = Data(contentsOf: self.worldMapURL)
        } catch { return }
        
        // deserialize
        guard let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data!) else { return }
        
        // resetting WorldMap
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.initialWorldMap = worldMap
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create and register scene
        sceneView.scene = SCNScene()
        
        // view feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // add light
        sceneView.autoenablesDefaultLighting = true
        
        // detection plane
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get touch coordinate
        guard let touch = touches.first else {return}
        
        // conversion screen coordinate
        let touchPos = touch.location(in: sceneView)
        
        // search AR anchor for touch place
        let hitTest = sceneView.hitTest(touchPos, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            // add anchor if touched coordinate can be get
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    func renderer(_ renderer:SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else {return}
        
        // load scene from scn file
        let scene = SCNScene(named: "art.scnassets/container.scn")
        
        // search node from scene
        let containerNode = (scene?.rootNode.childNode(withName: "container", recursively: false))!
        
        // add child node with detection plane
        node.addChildNode(containerNode)
    }
}
