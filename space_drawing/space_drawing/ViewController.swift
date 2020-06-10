//
//  ViewController.swift
//  space_drawing
//
//  Created by Ando on 2020/05/25.
//  Copyright © 2020 AND. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ColorSlider

class ViewController: UIViewController, ARSCNViewDelegate {

    private var drawingNodes = [GeometryNode]()

    private var isTouching = false {
        didSet {
            pen.isHidden = !isTouching
        }
    }

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var pen: UILabel!
    
    @IBOutlet var colorSlider: ColorSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // set debug option(feature points)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        // set scene
        sceneView.scene = SCNScene()
        
        // create configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        statusLabel.text = "Wait..."
        pen.isHidden = true

        // start session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    private func setupColorPicker() {
        colorSlider = ColorSlider(orientation: .vertical, previewView: nil)
    }

    private func reset() {
        for node in drawingNodes {
            node.removeFromParentNode()
        }
        drawingNodes.removeAll()
    }

    private func isReadyForDrawing(trackingState: ARCamera.TrackingState) -> Bool {
        switch trackingState {
        case .normal:
            return true
        default:
            return false
        }
    }

    private func worldPositionForScreenCenter() -> SCNVector3 {
        // get position screen center
        let screenBounds = UIScreen.main.bounds
        let center = CGPoint(x: screenBounds.midX, y:screenBounds.midY)

        // convert Three-dimensional vector
        let centerVec3 = SCNVector3Make(Float(center.x), Float(center.y), 0.99)

        // unproject(convert world position)
        return sceneView.unprojectPoint(centerVec3)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isTouching else {
            return
        }
        guard let currentDrawing = drawingNodes.last else {
            return
        }

        DispatchQueue.main.async(execute: {
            let vertice = self.worldPositionForScreenCenter()
            currentDrawing.addVertice(vertice)
        })
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("\(self.classForCoder)/\(#function), error: " + error.localizedDescription)
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("State: \(camera.trackingState)")

        let state = camera.trackingState
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let frame = sceneView.session.currentFrame else {return}
        guard isReadyForDrawing(trackingState: frame.camera.trackingState) else {return}

        let drawingNode = GeometryNode(color: colorSlider.color, lineWidth: 0.004)
        sceneView.scene.rootNode.addChildNode(drawingNode)
        drawingNodes.append(drawingNode)

        statusLabel.text = "Move your device."

        isTouching = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        statusLabel.text = "Touch the screen to draw."
    }
}
