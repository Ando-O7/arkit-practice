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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
}
