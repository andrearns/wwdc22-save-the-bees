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
    private let cam = SKCameraNode()
    private let motionManager = CMMotionManager()
    private var flyingAnimation: SKAction!
    private var darkOverlayNode: SKSpriteNode!
    var bee: BeeNode?
    var oldPosition = CGPoint()
    var totalDistance: CGFloat = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let bee = BeeNode(xPosition: self.frame.midX, yPosition: self.frame.midY)
        self.bee?.pollenNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.bee = bee
        self.bee?.physicsBody?.affectedByGravity = false
        
        addChild(bee)
        
        setupFlyingAnimation()
        self.bee?.run(flyingAnimation)
        
        self.camera = cam
        
        self.darkOverlayNode = SKSpriteNode(texture: nil, color: UIColor.black, size: frame.size)
        self.darkOverlayNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.darkOverlayNode.zPosition = 999
        self.hideDarkOverlay()
        self.addChild(darkOverlayNode)
        
        self.setupAccelerometer()
        
        self.bee!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.oldPosition = bee.position
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
    }
    
    // MARK: - Stage functions
    func stageOneTasksValidation() {
        print("Stage 1 tasks validation running")
        
        if gameViewModel?.dialogIndex == 1 {
            // Remember to change to 1500
            if totalDistance <= 500 {
                let deltaX = bee!.position.x - oldPosition.x
                let deltaY = bee!.position.y - oldPosition.y
                
                print("Delta X:", deltaX)
                print("Delta Y:", deltaY)
                
                let newDistance = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
                totalDistance += newDistance
                
                print("Total distance:", totalDistance)
                
                oldPosition = bee!.position
                
                if totalDistance >= 500 {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gameViewModel?.dialogIndex += 1
        }
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
                    flowerNode.hasPollen = false
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
                    closedFlowerNode.physicsBody?.categoryBitMask = UInt32(16)
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
            // Review
            spawnNewFlower(xPosition: openedFlowersPositionList[i].x, yPosition: openedFlowersPositionList[i].y, hasPollen: true, categoryBitMask: CategoryBitMask.pollenCategory)
        }
        
        for i in 0...(closedFlowersPositionList.count - 1) {
            spawnNewClosedFlower(xPosition: closedFlowersPositionList[i].x, yPosition: closedFlowersPositionList[i].y)
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
