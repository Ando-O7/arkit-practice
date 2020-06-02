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

    public func addVertice(_ vertice: SCNVector3) {
        var smoothed = SCNVector3Zero
        if verticesPool.count < 3 {
            if !SCNVector3EqualToVector3(vertice, SCNVector3Zero) {
                verticesPool.append(vertice)
            }
            return
        } else {
            for vertice in verticesPool {
                smoothed.x += vertice.x
                smoothed.y += vertice.y
                smoothed.z += vertice.z
            }
            smoothed.x /= Float(verticesPool.count)
            smoothed.y /= Float(verticesPool.count)
            smoothed.z /= Float(verticesPool.count)
            verticesPool.removeAll()
        }
        vertices.append(SCNVector3Make(smoothed.x, smoothed.y - lineWidth, smoothed.z))
        vertices.append(SCNVector3Make(smoothed.x, smoothed.y + lineWidth, smoothed.z))
        let count = vertices.count
        indices.append(Int32(count-2))
        indices.append(Int32(count-1))

        updateGeometry()
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
