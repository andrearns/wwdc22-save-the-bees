//
//  SceneManager.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SwiftUI
import SpriteKit

class GameViewModel: ObservableObject {
    var beeScene: BeeScene
    var currentStage: Stage
    @Published var dialogIndex = 0

    var currentStageIndex: Int {
        didSet {
            let newStage = StageBank.shared.stageList.first { stage in
                stage.index == currentStageIndex
            }
            if let stage = newStage {
                self.currentStage = stage
                self.beeScene.removeAllChildren()
                self.beeScene = stage.beeScene
            }
        }
    }
    
    init(currentStage: Stage, beeScene: BeeScene) {
        self.currentStageIndex = currentStage.index
        self.currentStage = currentStage
        self.beeScene = beeScene
        beeScene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        beeScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        beeScene.scaleMode = .aspectFit
    }
    
    func dialogTapHandle(normalDialogCompletion: () -> (), finalDialogCompletion: () -> ()) {
        if dialogIndex < currentStage.dialogList.count - 1 {
            normalDialogCompletion()
            dialogIndex += 1
        } else {
            finalDialogCompletion()
            dialogIndex = 0
        }
    }
}
