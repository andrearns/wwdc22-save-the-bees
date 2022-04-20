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
                if gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex].type == .text {
                    DialogView(dialog: $gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex])
                        .opacity(gameViewModel.isDialogOn ? 1 : 0)
                        .onTapGesture {
                            gameViewModel.dialogTapHandle()
                        }
                } else {
                    TaskView(dialog: $gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex])
                }
                
                NavigationLink("", isActive: $gameViewModel.showNextStage) {
                    StageIntroView(title: gameViewModel.currentStage.title, description: gameViewModel.currentStage.subtitle, gameViewModel: gameViewModel)
                }
                
                NavigationLink("", isActive: $gameViewModel.showFinalScreen, destination: {
                    FinalView()
                })
            }
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Image(gameViewModel.isDangerous ? "dangerRadarSprite" : "radarFrameSprite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: radarWidth, height: radarWidth)
                            .padding()
                        
                        if gameViewModel.currentStageIndex > 1 && gameViewModel.isGoalDisplayed {
                            FlowerGoalView(currentCount: $gameViewModel.flowersPollinated, goal: gameViewModel.currentStage.pollinationGoal!, maxWidth: radarWidth)
                                .padding(.top)
                        }
                    }
                }
                Spacer()
            }
            .opacity(gameViewModel.isRadarOn ? 1 : 0)
            
            if !gameViewModel.isGameOn {
                VStack {
                    Spacer()
                    FinalDialog()
                }
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            gameViewModel.currentStage.beeScene.physicsBody = SKPhysicsBody(edgeLoopFrom: CGPath(ellipseIn: gameViewModel.currentStage.rect, transform: .none))
        }
    }
}
