//
//  GameIntroView.swift
//  WWDC22
//
//  Created by André Arns on 15/04/22.
//

import SwiftUI

struct GameIntroView: View {
    @State var goNext: Bool = false
    
    var body: some View {
        ZStack {
            Image("gameIntroBackgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width + 40)
            NavigationLink("", isActive: $goNext, destination: {
                StageIntroView(title: "Stage 1", description: "First day at work")
            })
        }
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            goNext = true
        }
    }
}

struct GameIntroView_Previews: PreviewProvider {
    static var previews: some View {
        GameIntroView()
    }
}
