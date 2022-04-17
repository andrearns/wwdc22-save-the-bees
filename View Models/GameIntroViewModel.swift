//
//  File.swift
//  
//
//  Created by André Arns on 17/04/22.
//

import Foundation
import SwiftUI

class GameIntroViewModel: ObservableObject {
    @Published var dialogList: [Dialog] = DialogBank.shared.gameIntroDialogList
    @Published var dialogIndex = 0
    
    func dialogTapHandle(finalDialogCompletion: @escaping () -> ()) {
        if dialogIndex < dialogList.count - 1 {
            dialogIndex += 1
        } else {
            finalDialogCompletion()
        }
    }
}
