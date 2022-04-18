//
//  File.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import Foundation

final class DialogBank {
    static var shared = DialogBank()
    
    var gameIntroDialogList: [Dialog] = []
    var firstStageDialogList: [Dialog] = []
    var secondStageDialogList: [Dialog] = []
    var thirdStageDialogList: [Dialog] = []
    
    private init() {
        self.gameIntroDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "Your hour has come, you must work for me, my daughter. You must collect the nectar from the flowers to feed me."),
            Dialog(type: .text, speaker: .queenBee, text: "But first I need to teach you the basics, to save you from a tragic death."),
        ]
        
        self.firstStageDialogList = [
            Dialog(type: .task, speaker: .queenBee, text: "Ok, let's start! In order to fly, lean the device to the desired direction using the accelerometer."),
            Dialog(type: .text, speaker: .queenBee, text: "Okay okay! Great job little bee, you learn fast."),
            Dialog(type: .text, speaker: .queenBee, text: "I'm also giving you this radar, which will show where are the flowers full of pollen. Your other sisters are always updating it."),
            Dialog(type: .task, speaker: .queenBee, text: "Find a tasty flower using the radar and collect the pollen."),
            Dialog(type: .text, speaker: .workerBee, text: "Hmmmm... This is wonderful and delicious at the same time... This is wonderlicious!"),
            Dialog(type: .task, speaker: .queenBee, text: "Now that you took the pollen, find closed flowers to pollinate and secure our future."),
            Dialog(type: .text, speaker: .queenBee, text: "Great job, darling! Did you know that 70% of all plants are pollinated by ous? We have a huge responsability in the world."),
        ]
        
        self.secondStageDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "You are doing well so far..."),
            Dialog(type: .text, speaker: .queenBee, text: "Now you must take care, there are some deadly clouds caused by pesticides."),
            Dialog(type: .text, speaker: .queenBee, text: "If you get close to the cloud, you lose all the radar senses and you might get lost forever... So be careful and stay away from them."),
            Dialog(type: .task, speaker: .queenBee, text: "Now you need to collect enough nectar to bring home. Fill the nectar bar by collecting pollen."),
        ]
        
        self.thirdStageDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "Now you graduated. Congratulations, my darling!"),
            Dialog(type: .task, speaker: .queenBee, text: "Now pollinate the world!"),
        ]
    }
}
