import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @State var isRadarOn: Bool = false
    @State var isDialogOn: Bool = true
    @State var isDangerous: Bool = false
    @State var showNextStage: Bool = false
    @State var showFinalScreen: Bool = false
    
    var spriteView: SpriteView?
    var radarWidth: CGFloat {
        return UIScreen.main.bounds.width / 4
    }
    
    init(currentStage: Stage, beeScene: BeeScene) {
        self.gameViewModel = GameViewModel(currentStage: currentStage, beeScene: beeScene)
    }
    
    var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: gameViewModel.currentStage.beeScene)
            }
            VStack {
                Spacer()
                DialogView(dialog: $gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex])
                    .opacity(isDialogOn ? 1 : 0)
                    .onTapGesture {
                        gameViewModel.dialogTapHandle(
                            normalDialogCompletion: {
                                if gameViewModel.currentStageIndex == 1 {
                                    if gameViewModel.dialogIndex == 1 {
                                        isRadarOn = true
                                    }
                                }
                            },
                            finalDialogCompletion: {
                                if gameViewModel.currentStageIndex < StageBank.shared.stageList.count {
                                    showNextStage = true
                                } else {
                                    showFinalScreen = true
                                }
                                
                                gameViewModel.currentStageIndex += 1
                            }
                        )
                    }
                NavigationLink("", isActive: $showNextStage) {
                    StageIntroView(gameViewModel: gameViewModel, title: gameViewModel.currentStage.title, description: gameViewModel.currentStage.subtitle)
                }
                
                NavigationLink("", isActive: $showFinalScreen, destination: {
                    FinalView()
                })
            }
            VStack {
                HStack {
                    Spacer()
                    Image(isDangerous ? "dangerRadarSprite" : "radarFrameSprite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: radarWidth, height: radarWidth)
                        .padding()
                }
                Spacer()
            }
            .opacity(isRadarOn ? 1 : 0)
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
    }
}
