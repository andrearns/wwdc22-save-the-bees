import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var spriteView: SpriteView?
    var radarWidth: CGFloat {
        return UIScreen.main.bounds.width / 4
    }
    
    init(currentStage: Stage, beeScene: BeeScene) {
        self.gameViewModel = GameViewModel(currentStage: currentStage, beeScene: beeScene)
        if gameViewModel.currentStageIndex > 1 {
            self.gameViewModel.isRadarOn = true
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: gameViewModel.currentStage.beeScene)
            }
            VStack {
                Spacer()
                DialogView(dialog: $gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex])
                    .opacity(gameViewModel.isDialogOn ? 1 : 0)
                    .onTapGesture {
                        gameViewModel.dialogTapHandle()
                    }
                NavigationLink("", isActive: $gameViewModel.showNextStage) {
                    StageIntroView(gameViewModel: gameViewModel, title: gameViewModel.currentStage.title, description: gameViewModel.currentStage.subtitle)
                }
                
                NavigationLink("", isActive: $gameViewModel.showFinalScreen, destination: {
                    FinalView()
                })
            }
            VStack {
                HStack {
                    Spacer()
                    Image(gameViewModel.isDangerous ? "dangerRadarSprite" : "radarFrameSprite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: radarWidth, height: radarWidth)
                        .padding()
                }
                Spacer()
            }
            .opacity(gameViewModel.isRadarOn ? 1 : 0)
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
    }
}
