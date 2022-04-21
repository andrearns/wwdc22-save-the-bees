//
//  File.swift
//  
//
//  Created by André Arns on 20/04/22.
//

import Foundation
import SpriteKit

class FlowerPositionsBank {
    static var shared = FlowerPositionsBank()
    
    // FIRST STAGE
    var firstStageOpenedFlowersPositionList: [CGPoint] = []
    var firstStageClosedFlowersPositionList: [CGPoint] = []
    
    // SECOND STAGE
    var secondStageOpenedFlowersPositionList: [CGPoint] = []
    var secondStageClosedFlowersPositionList: [CGPoint] = []
    
    // THIRD STAGE
    var thirdStageOpenedFlowersPositionList: [CGPoint] = []
    var thirdStageClosedFlowersPositionList: [CGPoint] = []
    
    private init() {
        self.firstStageOpenedFlowersPositionList = [
            CGPoint(x: -529, y: 249),
            CGPoint(x: 529, y: 249),
            CGPoint(x: 0, y: -529)
        ]
        
        self.firstStageClosedFlowersPositionList = [
            CGPoint(x: 0, y: 529),
            CGPoint(x: -529, y: -249),
            CGPoint(x: 529, y: -249)
        ]
        
        self.secondStageOpenedFlowersPositionList = [
            CGPoint(x: 0, y: 1338),
            CGPoint(x: -888, y: 916),
            CGPoint(x: 974, y: 853),
            CGPoint(x: -1033, y: 0),
            CGPoint(x: -376, y: 0),
            CGPoint(x: 363, y: 0),
            CGPoint(x: 997, y: 0),
            CGPoint(x: -997, y: -927),
            CGPoint(x: 0, y: -1338),
            CGPoint(x: 997, y: -927)
        ]
        
        self.secondStageClosedFlowersPositionList = [
            CGPoint(x: -447, y: 1076),
            CGPoint(x: 519, y: 1096),
            CGPoint(x: -591, y: 530),
            CGPoint(x: 612, y: 560),
            CGPoint(x: -501, y: -471),
            CGPoint(x: 575, y: -471),
            CGPoint(x: -447, y: -958),
            CGPoint(x: 347, y: -929),
        ]
        
        self.thirdStageOpenedFlowersPositionList = [
            CGPoint(x: 0, y: 1338),
            CGPoint(x: -888, y: 916),
            CGPoint(x: 974, y: 853),
            CGPoint(x: -1033, y: 0),
            CGPoint(x: -376, y: 0),
            CGPoint(x: 363, y: 0),
            CGPoint(x: 997, y: 0),
            CGPoint(x: -997, y: -927),
            CGPoint(x: 0, y: -1338),
            CGPoint(x: 997, y: -927)
        ]
        
        self.thirdStageClosedFlowersPositionList = [
            CGPoint(x: -447, y: 1076),
            CGPoint(x: 519, y: 1096),
            CGPoint(x: -591, y: 530),
            CGPoint(x: 612, y: 560),
            CGPoint(x: -501, y: -471),
            CGPoint(x: 575, y: -471),
            CGPoint(x: -447, y: -958),
            CGPoint(x: 347, y: -929),
        ]
    }
}
