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
    
    @Published var isRadarOn: Bool = false
    @Published var showNextStage: Bool = false
    @Published var showFinalScreen: Bool = false
    @Published var isDialogOn: Bool = true
    @Published var isDangerous: Bool = false
    @Published var dialogIndex = 0

    var currentStageIndex: Int {
        didSet {
            let newStage = StageBank.shared.stageList.first { stage in
                stage.index == currentStageIndex
            }
            if let stage = newStage {
                self.currentStage = stage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.beeScene.removeAllChildren()
                    self.beeScene = stage.beeScene
                    self.beeScene.spawnFirstFlowers(stage.flowerCount)
                }
            }
        }
    }
    
    init(currentStage: Stage, beeScene: BeeScene) {
        self.currentStageIndex = currentStage.index
        self.currentStage = currentStage
        self.beeScene = beeScene
        self.beeScene.gameViewModel = self
        beeScene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        beeScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        beeScene.scaleMode = .aspectFit
    }
    
    func dialogTapHandle() {
        if dialogIndex < currentStage.dialogList.count - 1 {
            // STAGE 1
            if currentStageIndex == 1 {
                switch dialogIndex {
                case 0:
                    print("Dialog 0")
                case 1:
                    withAnimation {
                        isRadarOn = true
                        self.beeScene.showDarkOverlay()
                    }
                case 2:
                    withAnimation {
                        self.beeScene.spawnFirstFlowers(currentStage.flowerCount)
                        self.beeScene.hideDarkOverlay()
                    }
                case 3:
                    print("Dialog 3")
                case 5:
                    print("Dialog 5")
                default:
                    print("Dialog x")
                }
            }
            // STAGE 2
            else if currentStageIndex == 2 {
                
            }
            // STAGE 3
            else if currentStageIndex == 3 {
                
            }
            
//            if currentStage.dialogList[dialogIndex].type == .text {
                dialogIndex += 1
//            }
        } else {
            if currentStageIndex < StageBank.shared.stageList.count {
                showNextStage = true
            } else {
                isDialogOn = false
                showFinalScreen = true
            }
            
            currentStageIndex += 1
            
            dialogIndex = 0
        }
    }
}
