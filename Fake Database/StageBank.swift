//
//  File.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import Foundation
import SpriteKit

class StageBank {
    static var shared = StageBank()
    
    var stageList: [Stage] = []
    
    private init() {
        self.stageList = [
            Stage(
                title: "Stage 1",
                subtitle: "First day at work",
                index: 1,
                beeScene: SKScene(fileNamed: "Scene1") as! BeeScene,
                dialogList: DialogBank.shared.firstStageDialogList,
                rect: CGRect(x: -960, y: -960, width: 1920, height: 1920),
                openedFlowersPositionList: FlowerPositionsBank.shared.firstStageOpenedFlowersPositionList,
                closedFlowersPositionList: FlowerPositionsBank.shared.firstStageClosedFlowersPositionList
            ),
            
            Stage(
                title: "Stage 2",
                subtitle: "Entering the danger zone",
                index: 2,
                beeScene: SKScene(fileNamed: "Scene2") as! BeeScene,
                dialogList: DialogBank.shared.secondStageDialogList,
                rect: CGRect(x: -1660, y: -1660, width: 3320, height: 3320),
                pollinationGoal: 3,
                openedFlowersPositionList: FlowerPositionsBank.shared.secondStageOpenedFlowersPositionList,
                closedFlowersPositionList: FlowerPositionsBank.shared.secondStageClosedFlowersPositionList
            ),
            
            Stage(
                title: "Stage 3",
                subtitle: "Colorful world",
                index: 3,
                beeScene: SKScene(fileNamed: "Scene3") as! BeeScene,
                dialogList: DialogBank.shared.thirdStageDialogList,
                rect: CGRect(x: -1660, y: -1660, width: 3320, height: 3320),
                pollinationGoal: 6,
                openedFlowersPositionList: FlowerPositionsBank.shared.thirdStageOpenedFlowersPositionList,
                closedFlowersPositionList: FlowerPositionsBank.shared.thirdStageClosedFlowersPositionList
            )
        ]
    }
}
