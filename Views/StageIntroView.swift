//
//  StageIntroView.swift
//  Save the Bees
//
//  Created by André Arns on 23/04/22.
//

import SwiftUI

struct StageIntroView: View {
    var title: String
    var description: String
    
    @ObservedObject var gameViewModel: GameViewModel
    @State var showGameView: Bool = false
    @State var tapOpacity: Double = 0.1
    
    var body: some View {
        ZStack {
            VStack {
                Text(title.uppercased())
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(Color.beeYellow)
                    .padding(.bottom, 32)
                
                Text(description.uppercased())
                    .font(.system(size: 60, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                
                NavigationLink("", isActive: $showGameView, destination: {
                    GameView(currentStage: gameViewModel.currentStage, beeScene: gameViewModel.currentStage.beeScene)
                })
            }
            
            VStack {
                Spacer()
                Text("TAP TO CONTINUE")
                    .opacity(tapOpacity)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: tapOpacity)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.beeYellow)
                    .padding(.bottom, 120)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color.beeBrown)
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            withAnimation {
                showGameView = true
                gameViewModel.stopInitialSound()
            }
        }
        .onAppear {
            tapOpacity = 1
        }
    }
}
