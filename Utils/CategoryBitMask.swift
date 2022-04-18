//
//  File.swift
//  
//
//  Created by André Arns on 18/04/22.
//

import Foundation

enum CategoryBitMask {
    static let none: UInt32 =                    0b00000
    static let beeCategory: UInt32 =             0b00001
    static let pollenCategory: UInt32 =          0b00010
    static let closedFlowerCategory: UInt32 =    0b00100
    static let pesticideCategory: UInt32 =       0b01000
    static let sceneCategory: UInt32 =           0b10000
}
