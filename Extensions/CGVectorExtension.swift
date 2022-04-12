//
//  CGVectorExtension.swift
//  
//
//  Created by André Arns on 12/04/22.
//

import Foundation
import SpriteKit

extension CGVector {
    func module() -> CGFloat {
        sqrt(pow(self.dx, 2) + pow(self.dy, 2))
    }
    
    func angleRadians() -> CGFloat {
        return atan2(self.dy, self.dx)
    }
}
