//
//  GeometryNode.swift
//  space_drawing
//
//  Created by Ando on 2020/05/29.
//  Copyright © 2020 AND. All rights reserved.
//

import SceneKit

open class GeometryNode: SCNNode {

    private let lineWidth: Float
    private let color: UIColor

    public init(color: UIColor, lineWidth: Float) {
        self.color = color
        self.lineWidth = lineWidth
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
