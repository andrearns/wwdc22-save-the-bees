//
//  IntroView.swift
//  WWDC22
//
//  Created by André Arns on 15/04/22.
//

import SwiftUI

struct StageIntroView: View {
    var title: String
    var description: String
    @State var showGameView: Bool = false
    
    var body: some View {
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
                GameView()
            })
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color.beeBrown)
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            withAnimation {
                showGameView = true
            }
        }
    }
}

struct StageIntroView_Previews: PreviewProvider {
    static var previews: some View {
        StageIntroView(title: "Stage 1", description: "First day at work")
    }
}
