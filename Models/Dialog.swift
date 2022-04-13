//
//  File.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import Foundation

struct Dialog {
    var type: DialogType
    var speaker: DialogSpeaker
    var text: String
}

enum DialogType {
    case text
    case task
}

enum DialogSpeaker {
    case queenBee
    case workerBee
}
