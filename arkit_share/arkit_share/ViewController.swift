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
    var otherPeerID: MCPeerID?
    let colorTable = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.white, UIColor.black]
    var myColorIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting color
        myColorIdx = Int(arc4random_uniform(UInt32(colorTable.count)))
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    func receivedData(_ data: Data, from peer: MCPeerID) {
        do {
            // if receive data is ARWorldMap
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // run the session with the received world map
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                otherPeerID = peer
            }
        } catch {}
        do {
            // if receive data is ARAnchor
            if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                sceneView.session.add(anchor: anchor)
            }
        } catch {}
    }
}
