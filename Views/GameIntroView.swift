//
//  GameIntroView.swift
//  WWDC22
//
//  Created by André Arns on 15/04/22.
//

import SwiftUI

struct GameIntroView: View {
    @State var showFirstStage: Bool = false
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var gameIntroViewModel = GameIntroViewModel()
    
    var body: some View {
        ZStack {
            Image("gameIntroBackgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width + 40)
            
            VStack {
                Spacer()
                DialogView(dialog: $gameIntroViewModel.dialogList[gameIntroViewModel.dialogIndex])
                    .onTapGesture {
                        gameIntroViewModel.dialogTapHandle {
                            showFirstStage = true
                        }
                    }
                NavigationLink("", isActive: $showFirstStage) {
                    StageIntroView(title: gameViewModel.currentStage.title, description: gameViewModel.currentStage.subtitle, gameViewModel: gameViewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
    }
}

//struct GameIntroView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameIntroView()
//    }
//}
