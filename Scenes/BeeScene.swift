//
//  BeeScene.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SpriteKit
import CoreMotion
import SwiftUI

class BeeScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewModel: GameViewModel?
    
    var radarMaxDistance: CGFloat = UIScreen.main.bounds.height * 0.75
    var radarNode: SKSpriteNode!
    var dangerRadarNode: SKSpriteNode!
    var bee: BeeNode?
    var oldPosition = CGPoint()
    var totalDistance: CGFloat = 0
    var openedFlowerNodeList: [FlowerNode] = []
    var closedFlowerNodeList: [ClosedFlowerNode] = []
    var openedFlowerNodesInRadarList: [SKSpriteNode] = []
    var closedFlowerNodesInRadarList: [SKSpriteNode] = []
    
    private let cam = SKCameraNode()
    private let motionManager = CMMotionManager()
    private var flyingAnimation: SKAction!
    private var darkOverlayNode: SKSpriteNode!
    
    var radarWidth: CGFloat {
        UIScreen.main.bounds.width/4
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        setupRadar(openFlowersPositionList: gameViewModel!.currentStage.openedFlowersPositionList, closedFlowersPositionList: gameViewModel!.currentStage.closedFlowersPositionList)
        setupDangerRadar()
        
        self.bee = BeeNode(xPosition: self.frame.midX, yPosition: self.frame.midY)
        self.bee?.pollenNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.bee?.physicsBody?.affectedByGravity = false
        
        addChild(bee!)
        
        setupFlyingAnimation()
        self.bee?.run(flyingAnimation)
        
        self.camera = cam
        self.addChild(radarNode)
        
        self.darkOverlayNode = SKSpriteNode(texture: nil, color: UIColor.black, size: frame.size)
        self.darkOverlayNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.darkOverlayNode.zPosition = 999
        self.hideDarkOverlay()
        self.addChild(darkOverlayNode)
        
        self.setupAccelerometer()
        
        self.bee!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.oldPosition = bee!.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            if let currentVelocity = bee!.physicsBody?.velocity {
                if self.gameViewModel!.isDangerous {
                    physicsWorld.gravity = CGVector(dx: -accelerometerData.acceleration.x * 2, dy: -accelerometerData.acceleration.y * 2)
                } else {
                    physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 2, dy: accelerometerData.acceleration.y * 2)
                }
                
                self.bee!.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
                self.bee!.lastFacingDirection = currentVelocity
                self.bee?.pollenNode.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
            }
        }
        
        if self.gameViewModel!.isGameOn {
            let position = bee!.position
            cam.position = position
            self.darkOverlayNode.position = self.cam.position
        }
        
        if gameViewModel?.currentStageIndex == 1 {
            stageOneTasksValidation()
        } else if gameViewModel?.currentStageIndex == 2 {
            stageTwoTasksValidation()
        } else if gameViewModel?.currentStageIndex == 3 {
            stageThreeTasksValidation()
        }
        
        updateRadar(openedFlowerNodeList: openedFlowerNodeList, closedFlowerNodeList: closedFlowerNodeList)
    }
    
    // MARK: - Radar
    func setupRadar(openFlowersPositionList: [CGPoint], closedFlowersPositionList: [CGPoint]) {
        radarNode = SKSpriteNode(imageNamed: "radarFrameSprite")
        radarNode.size = CGSize(width: radarWidth, height: radarWidth)
        radarNode.alpha = 0
        radarNode.zPosition = 1007
        
        let radarLineNode = SKSpriteNode(imageNamed: "radarLineSprite")
        radarLineNode.size = CGSize(width: radarWidth, height: radarWidth)
        let spinAction = SKAction.repeatForever(SKAction.rotate(byAngle: -2 * .pi, duration: 4))
        
        radarNode.addChild(radarLineNode)
        radarLineNode.run(spinAction)
        
        createOpenFlowerNodesInRadar(openFlowersPositionList: openFlowersPositionList)
        createClosedFlowerNodesInRadar(closedFlowersPositionList: closedFlowersPositionList)
    }
    
    func setupDangerRadar() {
        dangerRadarNode = SKSpriteNode(imageNamed: "dangerRadarSprite")
        dangerRadarNode.size = CGSize(width: radarWidth, height: radarWidth)
        dangerRadarNode.alpha = 0
        dangerRadarNode.zPosition = 1007
        addChild(dangerRadarNode)
    }
    
    func showFlower(flowerRealPosition: CGPoint) -> Bool {
        let realDistance = getRealDistance(flowerPosition: flowerRealPosition)
        if realDistance > radarMaxDistance {
            return false
        } else {
            return true
        }
    }
    
    func getRealDistance(flowerPosition: CGPoint) -> CGFloat {
        if let bee = bee {
            let a = bee.position.y - flowerPosition.y
            let b = bee.position.x - flowerPosition.x
            let distance = sqrt(pow(a, 2) + pow(b, 2))
            return distance
        }
        return 0
    }
    
    func getGraphDistance(flowerPosition: CGPoint) -> CGFloat {
        let realDistance = getRealDistance(flowerPosition: flowerPosition)
        let proportionalDistance = (realDistance * radarWidth) / (radarMaxDistance * 2)
        return proportionalDistance
    }

    func createOpenFlowerNodesInRadar(openFlowersPositionList: [CGPoint]) {
        for _ in 0...openFlowersPositionList.count - 1 {
            let flowerDotNode = SKSpriteNode(imageNamed: "redFlowerSprite")
            flowerDotNode.size = CGSize(width: 30, height: 30)
            radarNode.addChild(flowerDotNode)
            openedFlowerNodesInRadarList.append(flowerDotNode)
            print("Open flower created in radar")
        }
    }
    
    func createClosedFlowerNodesInRadar(closedFlowersPositionList: [CGPoint]) {
        for _ in 0...closedFlowersPositionList.count - 1 {
            let closedFlowerDotNode = SKSpriteNode(imageNamed: "closedFlowerSprite")
            closedFlowerDotNode.size = CGSize(width: 20, height: 20)
            radarNode.addChild(closedFlowerDotNode)
            closedFlowerNodesInRadarList.append(closedFlowerDotNode)
            print("Closed flower created in radar")
        }
    }
    
    func updateOpenedFlowerNodePositionInRadar(openedFlowerNodeInRadar: SKSpriteNode, openedFlowerNode: FlowerNode) {
        if openedFlowerNode.hasPollen {
            let relativeXPosition = openedFlowerNode.position.x - bee!.position.x
            let relativeYPosition = openedFlowerNode.position.y - bee!.position.y
            
            let graphXPosition = relativeXPosition * radarWidth / (radarMaxDistance * 2)
            let graphYPosition = relativeYPosition * radarWidth / (radarMaxDistance * 2)
            
            openedFlowerNodeInRadar.position = CGPoint(x: graphXPosition, y: graphYPosition)
            
            if showFlower(flowerRealPosition: openedFlowerNode.position) {
                openedFlowerNodeInRadar.alpha = 1
            } else {
                openedFlowerNodeInRadar.alpha = 0
            }
        } else {
            openedFlowerNodeInRadar.alpha = 0
        }
    }
    
    func updateClosedFlowerNodePositionInRadar(closedFlowerNodeInRadar: SKSpriteNode, closedFlowerNode: ClosedFlowerNode) {
        let relativeXPosition = closedFlowerNode.position.x - bee!.position.x
        let relativeYPosition = closedFlowerNode.position.y - bee!.position.y
        
        let graphXPosition = relativeXPosition * radarWidth / (radarMaxDistance * 2)
        let graphYPosition = relativeYPosition * radarWidth / (radarMaxDistance * 2)
        
        closedFlowerNodeInRadar.position = CGPoint(x: graphXPosition, y: graphYPosition)
        
        if showFlower(flowerRealPosition: closedFlowerNode.position) {
            closedFlowerNodeInRadar.alpha = 1
        } else {
            closedFlowerNodeInRadar.alpha = 0
        }
    }
    
    func updateRadar(openedFlowerNodeList: [FlowerNode], closedFlowerNodeList: [ClosedFlowerNode]) {
        if gameViewModel!.isRadarOn {
            radarNode.alpha = 1
            radarNode.position = CGPoint(x: cam.position.x + frame.maxX - radarWidth/2 - 16, y: cam.position.y + frame.maxY - radarWidth/2 - 16)
            dangerRadarNode.position = radarNode.position
            
            if gameViewModel!.isDangerous {
                radarNode.alpha = 0
                dangerRadarNode.alpha = 1
            } else {
                radarNode.alpha = 1
                dangerRadarNode.alpha = 0
            }
            
            if openedFlowerNodeList.count > 0 {
                for i in 0...openedFlowerNodesInRadarList.count - 1 {
                    updateOpenedFlowerNodePositionInRadar(openedFlowerNodeInRadar: openedFlowerNodesInRadarList[i], openedFlowerNode: openedFlowerNodeList[i])
                }
                
                for i in 0...closedFlowerNodesInRadarList.count - 1 {
                    updateClosedFlowerNodePositionInRadar(closedFlowerNodeInRadar: closedFlowerNodesInRadarList[i], closedFlowerNode: closedFlowerNodeList[i])
                }
            }
        } else {
            radarNode.alpha = 0
        }
    }
    
    // MARK: - Stage functions
    func stageOneTasksValidation() {
        print("Stage 1 tasks validation running")
        
        if gameViewModel?.dialogIndex == 1 {
            if totalDistance <= 1200 {
                let deltaX = bee!.position.x - oldPosition.x
                let deltaY = bee!.position.y - oldPosition.y
                
                print("Delta X:", deltaX)
                print("Delta Y:", deltaY)
                
                let newDistance = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
                totalDistance += newDistance
                
                print("Total distance:", totalDistance)
                
                oldPosition = bee!.position
                
                if totalDistance >= 1200 {
                    print("Player has learned how to fly")
                    completeTask()
                }
            }
        }
        else if gameViewModel?.dialogIndex == 4 {
            print("Player need to find a flower with pollen")
            if bee!.hasPollen {
                completeTask()
            }
        }
        else if gameViewModel?.dialogIndex == 6 {
            print("Player need to pollinate closed flower")
            if gameViewModel!.flowersPollinated > 0 {
                completeTask()
            }
        }
    }
    
    func stageTwoTasksValidation() {
        print("Stage 2 tasks validation running")
        if gameViewModel?.flowersPollinated == gameViewModel?.currentStage.pollinationGoal && gameViewModel?.dialogIndex == 4 {
            completeTask()
        }
    }
    
    func stageThreeTasksValidation() {
        print("Stage 3 tasks validation running")
        if gameViewModel?.flowersPollinated == gameViewModel?.currentStage.pollinationGoal && gameViewModel?.dialogIndex == 2 {
            completeTask()
        }
    }
    
    func completeTask() {
        self.gameViewModel?.currentStage.dialogList[self.gameViewModel!.dialogIndex].isDone = true
        self.gameViewModel?.dialogIndex += 1
    }
    
    // MARK: - Overlays
    func showDarkOverlay() {
        self.darkOverlayNode.alpha = 0.5
    }
    
    func hideDarkOverlay() {
        self.darkOverlayNode.alpha = 0
    }
    
    // MARK: - Bee animation
    func setupFlyingAnimation() {
        var flyingTextureList: [SKTexture] = []
        
        for i in 1...6 {
            flyingTextureList.append(SKTexture(imageNamed: "beeAnimation\(i)"))
        }
        
        flyingAnimation = SKAction.repeatForever(SKAction.animate(with: flyingTextureList, timePerFrame: 0.03))
    }
    
    // MARK: - Accelerometer
    func setupAccelerometer() {
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.accelerometerUpdateInterval = 0.1
    }
    
    // MARK: - Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Collect pollen
        if firstBody.categoryBitMask == CategoryBitMask.beeCategory && secondBody.categoryBitMask == CategoryBitMask.pollenCategory {
            if bee!.hasPollen == false {
                print("Collect pollen")
                // Remove pollen node from contacted flower
                if let flowerNode = secondBody.node as? FlowerNode {
                    let index = openedFlowerNodeList.firstIndex { openedFlowerNode in
                        let hasSimilarXPosition = openedFlowerNode.position.x.rounded() == flowerNode.position.x.rounded()
                        let hasSimilarYPosition = openedFlowerNode.position.y.rounded() == flowerNode.position.y.rounded()
                        return (hasSimilarXPosition && hasSimilarYPosition)
                    }
                    
                    openedFlowerNodeList[index!].hasPollen = false
                    flowerNode.hasPollen = false
                    
                    openedFlowerNodeList[index!].physicsBody?.categoryBitMask = CategoryBitMask.none
                    flowerNode.physicsBody?.categoryBitMask = CategoryBitMask.none
                }
                
                // Add orbital pollen to the bee
                self.bee?.hasPollen = true
            }
        }
        // Collision with closed flower
        else if firstBody.categoryBitMask == CategoryBitMask.beeCategory && secondBody.categoryBitMask == CategoryBitMask.closedFlowerCategory {
            print("Collision with closed flower")
            
            if bee!.hasPollen {
                print("Grow flowers")
                bee!.removePollen()
                
                if let closedFlowerNode = secondBody.node as? ClosedFlowerNode {
                    closedFlowerNode.texture = SKTexture(imageNamed: "redFlowerSprite")
                    closedFlowerNode.physicsBody?.categoryBitMask = CategoryBitMask.none
                }
                
                growFlowersAfterPollination(xPosition: secondBody.node!.position.x, yPosition: secondBody.node!.position.y)
                gameViewModel!.flowersPollinated += 1
            }
        }
        // Collision with pesticide
        else if firstBody.categoryBitMask == CategoryBitMask.beeCategory && secondBody.categoryBitMask == CategoryBitMask.pesticideCategory {
            print("Collision with pesticide")
            withAnimation {
                gameViewModel?.isDangerous = true
                bee?.color = .black
                bee?.colorBlendFactor = 0.6
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == CategoryBitMask.beeCategory && secondBody.categoryBitMask == CategoryBitMask.pesticideCategory {
            print("Collision with pesticide ended")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.gameViewModel?.isDangerous = false
                    self.bee?.colorBlendFactor = 0
                }
            }
        }
    }
    
    // MARK: - Flowers
    func spawnFirstFlowers(openedFlowersPositionList: [CGPoint], closedFlowersPositionList: [CGPoint]) {
        for i in 0...(openedFlowersPositionList.count - 1) {
            let newOpenedFlower = FlowerNode(xPosition: openedFlowersPositionList[i].x, yPosition: openedFlowersPositionList[i].y, hasPollen: true, scale: getRandomScale(), categoryBitMask: CategoryBitMask.pollenCategory)
            self.openedFlowerNodeList.append(newOpenedFlower)
            spawnNewFlower(xPosition: newOpenedFlower.position.x, yPosition: newOpenedFlower.position.y, hasPollen: true, categoryBitMask: CategoryBitMask.pollenCategory)
        }
        
        for i in 0...(closedFlowersPositionList.count - 1) {
            let newClosedFlower = ClosedFlowerNode(xPosition: closedFlowersPositionList[i].x, yPosition: closedFlowersPositionList[i].y, scale: getRandomScale())
            self.closedFlowerNodeList.append(newClosedFlower)
            spawnNewClosedFlower(xPosition: newClosedFlower.position.x, yPosition: newClosedFlower.position.y)
        }
    }
    
    func growFlowersAfterPollination(xPosition: CGFloat, yPosition: CGFloat) {
        for _ in 0...6 {
            let randomCloseXPosition = getRandomXPosition(minimumXPosition: xPosition - 100, maximumXPosition: xPosition + 100)
            let randomCloseYPosition = getRandomYPosition(minimumYPosition: yPosition - 100, maximumYPosition: yPosition + 100)
            spawnNewFlower(xPosition: randomCloseXPosition, yPosition: randomCloseYPosition, hasPollen: false, categoryBitMask: CategoryBitMask.none)
        }
    }
    
    func spawnNewFlower(xPosition: CGFloat, yPosition: CGFloat, hasPollen: Bool, categoryBitMask: UInt32) {
        let newFlower = FlowerNode(xPosition: xPosition, yPosition: yPosition, hasPollen: hasPollen, scale: 0, categoryBitMask: categoryBitMask)
        self.addChild(newFlower)
        
        // SKAction to make the flower grow
        let action = SKAction.scale(to: getRandomScale(), duration: 1)
        newFlower.run(action)
    }
    
    func spawnNewClosedFlower(xPosition: CGFloat, yPosition: CGFloat) {
        let newClosedFlower = ClosedFlowerNode(xPosition: xPosition, yPosition: yPosition, scale: 0)
        self.addChild(newClosedFlower)
        
        // SKAction to make the closed flower grow
        let action = SKAction.scale(to: getRandomScale(), duration: 1)
        newClosedFlower.run(action)
    }
    
    func getRandomXPosition(minimumXPosition: CGFloat, maximumXPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumXPosition...maximumXPosition)
    }
    
    func getRandomYPosition(minimumYPosition: CGFloat, maximumYPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumYPosition...maximumYPosition)
    }
    
    func getRandomScale() -> CGFloat {
        CGFloat.random(in: (0.8)...(1.2))
    }
}
