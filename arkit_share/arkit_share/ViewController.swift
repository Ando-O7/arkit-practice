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
    static let serviceType = "ar-multi-sample"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var mpsessoin: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrowser: MCNearbyServiceBrowser!
    var otherPeerID: MCPeerID?
    private var mpsession: MCSession!
    let colorTable = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.white, UIColor.black]
    var myColorIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting color
        myColorIdx = Int(arc4random_uniform(UInt32(colorTable.count)))
        
        // init MultipeerConnectiveity
        initMultipeerSession(recevieDataHandler: receivedData)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create scene
        sceneView.scene = SCNScene()
        
        // view feature points for debug
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // add light
        sceneView.autoenablesDefaultLighting = true
        
        // detection horizontal plane
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
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
    
    func initMultipeerSession(recevieDataHandler: @escaping (Data, MCPeerID) -> Void) {
        mpsession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        mpsession.delegate = self
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: ViewController.serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: ViewController.serviceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
}
