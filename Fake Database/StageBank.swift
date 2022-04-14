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
            Stage(index: 0, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.firstStageDialogList),
            Stage(index: 1, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.secondStageDialogList),
            Stage(index: 2, beeScene: SKScene(fileNamed: "Scene1") as! BeeScene, dialogList: DialogBank.shared.thirdStageDialogList)
        ]
    }
}
