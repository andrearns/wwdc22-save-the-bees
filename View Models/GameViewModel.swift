//
//  SceneManager.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFoundation

class GameViewModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var beeScene: BeeScene
    var currentStage: Stage
    
    @Published var isRadarOn: Bool = false
    @Published var showNextStage: Bool = false
    @Published var isDialogOn: Bool = true
    @Published var isDangerous: Bool = false
    @Published var isGoalDisplayed: Bool = false
    @Published var isGameOn = true
    @Published var dialogIndex = 0
    @Published var flowersPollinated = 0

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
                if dialogIndex == 0 {
                    self.beeScene.bee!.physicsBody?.affectedByGravity = true
                } else if dialogIndex == 2 {
                    withAnimation {
                        isRadarOn = true
                        self.beeScene.showDarkOverlay()
                    }
                } else if dialogIndex == 3 {
                    withAnimation {
                        self.beeScene.spawnFirstFlowers(openedFlowersPositionList: currentStage.openedFlowersPositionList, closedFlowersPositionList: currentStage.closedFlowersPositionList)
                        self.beeScene.hideDarkOverlay()
                    }
                }
            }
            // STAGE 2
            else if currentStageIndex == 2 {
                if dialogIndex == 3 {
                    self.beeScene.spawnFirstFlowers(openedFlowersPositionList: currentStage.openedFlowersPositionList, closedFlowersPositionList: currentStage.closedFlowersPositionList)
                    self.isGoalDisplayed = true
                    self.beeScene.bee!.physicsBody?.affectedByGravity = true
                }
            }
            // STAGE 3
            else if currentStageIndex == 3 {
                if dialogIndex == 1 {
                    self.beeScene.spawnFirstFlowers(openedFlowersPositionList: currentStage.openedFlowersPositionList, closedFlowersPositionList: currentStage.closedFlowersPositionList)
                    self.isGoalDisplayed = true
                    self.beeScene.bee!.physicsBody?.affectedByGravity = true
                }
            }
            
            dialogIndex += 1
        } else {
            if currentStageIndex < StageBank.shared.stageList.count {
                showNextStage = true
            } else {
                isDialogOn = false
                showFinalView()
            }
            
            currentStageIndex += 1
            
            flowersPollinated = 0
            dialogIndex = 0
        }
    }
    
    func showFinalView() {
        withAnimation(Animation.easeInOut(duration: 2)) {
            if UIScreen.main.bounds.width < 800 {
                self.beeScene.camera?.setScale(6)
                beeScene.camera?.position = CGPoint(x: 0, y: -800)
            } else {
                self.beeScene.camera?.setScale(5)
                beeScene.camera?.position = CGPoint(x: 0, y: -1000)
            }
        }

        isRadarOn = false
        isGoalDisplayed = false
        isGameOn = false
    }
    
    func playInitialSound() {
//        if let path = Bundle.main.path(forResource: "SoundIntro-WWDC22", ofType: "mp3") {
//            do {
//                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//                self.audioPlayer?.play()
//                self.audioPlayer?.numberOfLoops = 100
//            } catch {
//                print("Error")
//            }
//        }
    }
    
    func stopInitialSound() {
        self.audioPlayer?.stop()
    }
    
    // Radar
    func showFlower(flowerRealPosition: CGPoint) -> Bool {
        let realDistance = getRealDistance(flowerPosition: flowerRealPosition)
        if realDistance > 640 {
            return false
        } else {
            return true
        }
    }
    
    func getRealDistance(flowerPosition: CGPoint) -> CGFloat {
        if let bee = beeScene.bee {
            let a = bee.position.y - flowerPosition.y
            let b = bee.position.x - flowerPosition.x
            let distance = sqrt(pow(a, 2) + pow(b, 2))
            return distance
        }
        return 0
    }
    
    func getGraphDistance(flowerPosition: CGPoint, radarWidth: CGFloat) -> CGFloat {
        let realDistance = getRealDistance(flowerPosition: flowerPosition)
        let proportionalDistance = (realDistance * radarWidth)/1280
        return proportionalDistance
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }

    func getAngle(flowerPosition : CGPoint) -> CGFloat {
        if let bee = beeScene.bee {
            let y = bee.position.y - flowerPosition.y
            let hip = getRealDistance(flowerPosition: flowerPosition)
            let sin = y/hip
            let arcsen = asin(sin)
            return arcsen
        }
        return 0
    }
}
