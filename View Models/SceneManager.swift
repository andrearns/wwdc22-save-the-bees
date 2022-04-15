//
//  SceneManager.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SwiftUI
import SpriteKit

class SceneManager: ObservableObject {
    var currentStageIndex: Int = 0 {
        didSet {
            let newStage = StageBank.shared.stageList.first { stage in
                stage.index == currentStageIndex
            }
            if let stage = newStage {
                currentStage = stage
                beeScene = currentStage.beeScene
            }
        }
    }
    
    var beeScene: BeeScene
    var currentStage: Stage = StageBank.shared.stageList[0]
    
    init() {
        self.beeScene = currentStage.beeScene
        beeScene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        beeScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        beeScene.scaleMode = .aspectFit
        
        // Only for debug
        self.beeScene.view?.showsPhysics = true
    }
}
