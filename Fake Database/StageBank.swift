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
            Stage(title: "Stage 1", subtitle: "First day at work", index: 1, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.firstStageDialogList, flowerCount: 2),
            Stage(title: "Stage 2", subtitle: "Entering the danger zone", index: 2, beeScene: SKScene(fileNamed: "Scene2") as! BeeScene, dialogList: DialogBank.shared.secondStageDialogList, flowerCount: 5),
            Stage(title: "Stage 3", subtitle: "Colorful world", index: 3, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.thirdStageDialogList, flowerCount: 8)
        ]
    }
}
