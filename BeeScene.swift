//
//  BeeScene.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SpriteKit
import CoreMotion

class BeeScene: SKScene, SKPhysicsContactDelegate {
    
    private let cam = SKCameraNode()
    private let motionManager = CMMotionManager()
    private let beeSpriteNode = SKSpriteNode(imageNamed: "beeSprite")
    private var numberOfFlowersAlive = 0
    
    var lastFacingDirection: CGVector = CGVector(dx: 0, dy: 0) {
        didSet {
            if lastFacingDirection == .zero {
                lastFacingDirection = oldValue
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        
        self.setupAccelerometer()
        self.setupBee()
        
        spawnNewFlower(xPosition: getRandomXPosition(), yPosition: getRandomYPosition())
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            if let currentVelocity = beeSpriteNode.physicsBody?.velocity {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 3, dy: accelerometerData.acceleration.y * 3)
                
                self.beeSpriteNode.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
                self.lastFacingDirection = currentVelocity
            }
        }
        
        let position = beeSpriteNode.position
        cam.position = position
    }
    
    func setupBee() {
        beeSpriteNode.position = CGPoint(x: frame.midX, y: frame.midY)
        beeSpriteNode.size = CGSize(width: 169, height: 165)
        self.addChild(beeSpriteNode)
        
        beeSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        beeSpriteNode.physicsBody?.allowsRotation = true
        beeSpriteNode.physicsBody?.restitution = 0.5
        beeSpriteNode.zPosition = 1000
        beeSpriteNode.physicsBody?.categoryBitMask = UInt32(2)
        beeSpriteNode.physicsBody?.collisionBitMask = UInt32(1)
        beeSpriteNode.physicsBody?.contactTestBitMask = UInt32(15)
    }
    
    func setupAccelerometer() {
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.accelerometerUpdateInterval = 0.1
    }
    
    func spawnNewFlower(xPosition: CGFloat, yPosition: CGFloat) {
        let newFlower = Flower(imageName: "redFlowerSprite", xPosition: xPosition, yPosition: yPosition, scene: self)
        self.addChild(newFlower.spriteNode)
    }
    
    func getRandomXPosition() -> CGFloat {
        // Review: make flexible to the scene size
        let minimumXPosition: CGFloat = -600
        let maximumXPosition: CGFloat = 600
        return CGFloat.random(in: minimumXPosition...maximumXPosition)
    }
    
    func getRandomYPosition() -> CGFloat {
        // Review: make flexible to the scene size
        let minimumYPosition: CGFloat = -600
        let maximumYPosition: CGFloat = 600
        return CGFloat.random(in: minimumYPosition...maximumYPosition)
    }
    
    // Collisions
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
        if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(4) {
            print("Collect pollen")
            
        }
    }
}
