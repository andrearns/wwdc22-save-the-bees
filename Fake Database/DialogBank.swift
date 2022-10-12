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
        // INTRO
        self.gameIntroDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "Your time has come, my daughter. You must work for me collecting the nectar from the flowers to feed me."),
            Dialog(type: .text, speaker: .queenBee, text: "But first I need to teach you the basics, to save you from a tragic death."),
        ]
        
        // FIRST STAGE: FIRST DAY AT WORK
        self.firstStageDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "Ok! First you need to learn how to fly around."),
            Dialog(type: .task, speaker: .queenBee, text: "In order to fly, keep the device stable and tilt to the  desired direction using the accelerometer."),
            Dialog(type: .text, speaker: .queenBee, text: "Okay okay! Great job little bee, you learn fast."),
            Dialog(type: .text, speaker: .queenBee, text: "I'm also giving you this radar, which will show where are the flowers full of pollen. Your other sisters are always updating it."),
            Dialog(type: .text, speaker: .queenBee, text: "The pink flowers with yellow dots inside have pollen and the flowers without it can be pollinated when you have pollen."),
            Dialog(type: .task, speaker: .queenBee, text: "Find a tasty flower using the radar and collect the pollen."),
            Dialog(type: .text, speaker: .workerBee, text: "Hmmmm... This is wonderful and delicious at the same time... This is wonderlicious!"),
            Dialog(type: .task, speaker: .queenBee, text: "Now that you took the pollen, find closed flowers to pollinate and grow more flowers."),
            Dialog(type: .text, speaker: .queenBee, text: "Great job, darling! Did you know that 80% of all floweringplants are pollinated by ous? We have a huge responsability in the world."),
        ]
        
        // SECOND STAGE: ENTERING THE DANGER ZONE
        self.secondStageDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "You are doing well so far..."),
            Dialog(type: .text, speaker: .queenBee, text: "Now you must take care, there are some deadly clouds caused by pesticides."),
            Dialog(type: .text, speaker: .queenBee, text: "If you get close to the cloud, you lose all the radar senses and you might get lost forever... So be careful and stay away from them."),
            Dialog(type: .text, speaker: .queenBee, text: "Now you have a goal to collect pollen and pollinate 3 other flowers. Are you ready?"),
            Dialog(type: .task, speaker: .queenBee, text: "Pollinate 3 pink flowers."),
            Dialog(type: .text, speaker: .queenBee, text: "I'm glad that you completed your goal and you are still alive! A lot of your sisters have died because of the pesticides lately."),
        ]
        
        // THIRD STAGE: COLORFUL WORLD
        self.thirdStageDialogList = [
            Dialog(type: .text, speaker: .queenBee, text: "Now you graduated. Congratulations, my darling!"),
            Dialog(type: .text, speaker: .queenBee, text: "In this place there are multiple flowers. I'm assigning you a pro mission: you need to collect 6 flowers."),
            Dialog(type: .task, speaker: .queenBee, text: "Pollinate 6 pink flowers colors."),
            Dialog(type: .text, speaker: .queenBee, text: "Great job, my daughter! You have completed your mission for today."),
        ]
    }
}
