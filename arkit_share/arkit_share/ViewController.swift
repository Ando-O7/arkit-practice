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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if((anchor as? ARPlaneAnchor) != nil) { return }
        
        // create node
        let sphereNode = SCNNode()
        let sphereGeometry = SCNSphere(radius: 0.03)
        
        // setting sphere color
        if let name = anchor.name{
            sphereGeometry.materials.first?.diffuse.contents = colorTable[Int(name)!]
        }
        
        // register geometry
        sphereNode.geometry = sphereGeometry
        sphereNode.position.y += 0.03
        
        node.addChildNode(sphereNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get touch coordinate
        guard let touch = touches.first else {return}
        
        // conversion to screen coordinate
        let touchPos = touch.location(in: sceneView)
        
        // search AR anchor for touch coordinate
        let hitTest = sceneView.hitTest(touchPos, types: .existingPlaneUsingExtent)
        
        // case of touch horizontal palane
        if !hitTest.isEmpty {
            // setting color index for anchor name
            let anchor = ARAnchor(name: String(myColorIdx), transform: hitTest.first!.worldTransform)
            
            sceneView.session.add(anchor: anchor)
            
            // added information of anchor send to partner
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) else { fatalError("can't encode anchor")}
            self.sendToAllPeers(data)
        }
    }
    
    @IBAction func shareButtonPressed(_ button: UIButton) {
        // get world map
        sceneView.session.getCurrentWorldMap { worldMap, error in guard let map = worldMap else {return}
            // serialize data
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) else {fatalError("can't encode map")}
            // send partner device
            self.sendToAllPeers(data)
        }
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

extension ViewController: MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate{
    
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
    
    func sendToAllPeers(_ data: Data) {
        do {
            try mpsession.send(data, toPeers: mpsession.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
    
    var connectedPeers: [MCPeerID] {
        return mpsession.connectedPeers
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedData(data, from: peerID)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        browser.invitePeer(peerID, to: mpsession, withContext: nil, timeout: 10)
    }
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.mpsession)
    }
}
