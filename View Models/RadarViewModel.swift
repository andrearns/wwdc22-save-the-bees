//
//  File.swift
//  
//
//  Created by André Arns on 21/04/22.
//

// REMEMBER TO REMOVE THIS

import Foundation
import SpriteKit

class RadarViewModel: ObservableObject {
    
    @Published var beeScene: BeeScene
    @Published var isDangerous: Bool
    var width: CGFloat
    
    init(beeScene: BeeScene, width: CGFloat) {
        self.isDangerous = false
        self.beeScene = beeScene
        self.width = width
    }
    
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
    
    func getGraphDistance(flowerPosition: CGPoint) -> CGFloat {
        let realDistance = getRealDistance(flowerPosition: flowerPosition)
        let proportionalDistance = (realDistance * width)/1280
        return proportionalDistance
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
