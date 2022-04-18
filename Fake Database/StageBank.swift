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
            Stage(title: "Stage 1", subtitle: "First day at work", index: 1, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.firstStageDialogList, flowerCount: 2, rect: CGRect(x: -960, y: -960, width: 1920, height: 1920)),
            Stage(title: "Stage 2", subtitle: "Entering the danger zone", index: 2, beeScene: SKScene(fileNamed: "Scene2") as! BeeScene, dialogList: DialogBank.shared.secondStageDialogList, flowerCount: 3, rect: CGRect(x: -1660, y: -1660, width: 3320, height: 3320)),
            Stage(title: "Stage 3", subtitle: "Colorful world", index: 3, beeScene: SKScene(fileNamed: "Scene3") as! BeeScene, dialogList: DialogBank.shared.thirdStageDialogList, flowerCount: 5, rect: CGRect(x: -1660, y: -1660, width: 3320, height: 3320))
        ]
    }
}
