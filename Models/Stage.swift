//
//  File 2.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import Foundation
import SpriteKit

struct Stage {
    var title: String
    var subtitle: String
    var index: Int
    var beeScene: BeeScene
    var dialogList: [Dialog]
    var rect: CGRect
    var pollinationGoal: Int?
    var openedFlowersPositionList: [CGPoint]
    var closedFlowersPositionList: [CGPoint]
}
