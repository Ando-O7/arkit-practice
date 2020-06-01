//
//  GeometryNode.swift
//  space_drawing
//
//  Created by Ando on 2020/05/29.
//  Copyright © 2020 AND. All rights reserved.
//

import SceneKit

open class GeometryNode: SCNNode {

    private var vertices: [SCNVector3] = []
    private var indices: [Int32] = []
    private let lineWidth: Float
    private let color: UIColor
    private var verticesPool: [SCNVector3] = []

    public init(color: UIColor, lineWidth: Float) {
        self.color = color
        self.lineWidth = lineWidth
        super.init()
    }

    private func updateGeometry() {
        guard vertices.count >= 3 else {
            return // not vertices
        }

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        geometry = SCNGeometry(sources: [source], elements: [element])
        if let material = geometry?.firstMaterial {
            material.diffuse.contents = color
            material.isDoubleSided = true
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reset() {
        verticesPool.removeAll()
        vertices.removeAll()
        indices.removeAll()
        geometry = nil
    }
}
