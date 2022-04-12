//
//  BeeScene.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SpriteKit
import CoreMotion

class BeeScene: SKScene {
    
    private let cam = SKCameraNode()
    private let motionManager = CMMotionManager()
    private let beeSpriteNode = SKSpriteNode(imageNamed: "beeSprite")
    
    var lastFacingDirection: CGVector = CGVector(dx: 0, dy: 0) {
        didSet {
            if lastFacingDirection == .zero {
                lastFacingDirection = oldValue
            }
        }
    }
    
    override func didMove(to view: SKView) {
        self.camera = cam
        
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.accelerometerUpdateInterval = 0.1
        
        beeSpriteNode.position = CGPoint(x: frame.midX, y: frame.midY)
        beeSpriteNode.size = CGSize(width: 169, height: 165)
        self.addChild(beeSpriteNode)
        
        beeSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        beeSpriteNode.physicsBody?.allowsRotation = true
        beeSpriteNode.physicsBody?.restitution = 0.5
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 3, dy: accelerometerData.acceleration.y * 3)
            
            print("Accelerometer X data:", accelerometerData.acceleration.x)
            print("Accelerometer Y data:", accelerometerData.acceleration.y)
            
            if let currentVelocity = beeSpriteNode.physicsBody?.velocity {
                let currentSpeed = currentVelocity.module()
                
                print("Bee velocity: ", beeSpriteNode.physicsBody?.velocity as Any)
                
                if currentSpeed > 0.01 {
                    self.beeSpriteNode.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
                }
                self.lastFacingDirection = currentVelocity
            }
        }
        
        let position = beeSpriteNode.position
        cam.position = position
    }
}

extension CGVector {
    func module() -> CGFloat {
        sqrt(pow(self.dx, 2) + pow(self.dy, 2))
    }
    
    func angleRadians() -> CGFloat {
        return atan2(self.dy, self.dx)
    }
}
