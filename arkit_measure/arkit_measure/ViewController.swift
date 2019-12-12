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
    var tapCount = 0
    var startPos = SIMD3<Float>(0, 0, 0)
    var currentPos = SIMD3<Float>(0, 0, 0)
    
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // placement sphere
        putSphere(at:currentPos)

        if tapCount == 0 // first tap
        {
            startPos = currentPos
            tapCount = 1
        }
        else // second tap
        {
            tapCount = 0
            let lineNode = drawLine(from: SCNVector3(startPos), to: SCNVector3(currentPos))
            sceneView.scene.rootNode.addChildNode(lineNode)
        }
    }

    func drawLine(from: SCNVector3, to: SCNVector3) -> SCNNode
    {
        // create geometory of straight line
        let source = SCNGeometrySource(vertices: [from, to])
        let element = SCNGeometryElement(data: Data.init(_: [0, 1]), primitiveType: .line, primitiveCount: 1, bytesPerIndex: 1)

        let geometry = SCNGeometry(sources: [source], elements: [element])

        // create staraight line node
        let node = SCNNode()
        node.geometry = geometry
        node.geometry?.materials.first?.diffuse.contents = UIColor.white
        return node
    }
}
