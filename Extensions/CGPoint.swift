//
//  File.swift
//  
//
//  Created by André Arns on 20/04/22.
//

import Foundation
import SpriteKit

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x + self.y)
    }
}
