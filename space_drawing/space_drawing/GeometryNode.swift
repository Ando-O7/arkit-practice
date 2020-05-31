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

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
