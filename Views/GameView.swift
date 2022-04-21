import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var spriteView: SpriteView?
    var radarWidth: CGFloat {
        return UIScreen.main.bounds.width / 4
    }
    @State var finalDialogPaddingBottom: CGFloat = -UIScreen.main.bounds.height/2
    
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
                    TaskView(dialog: $gameViewModel.currentStage.dialogList[gameViewModel.dialogIndex]) {
                        gameViewModel.dialogIndex += 1
                    }
                }
                
                NavigationLink("", isActive: $gameViewModel.showNextStage) {
                    StageIntroView(title: gameViewModel.currentStage.title, description: gameViewModel.currentStage.subtitle, gameViewModel: gameViewModel)
                }
            }
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        RadarView(gameViewModel: self.gameViewModel, width: radarWidth, isDangerous: gameViewModel.isDangerous, openFlowersPositionList: gameViewModel.currentStage.openedFlowersPositionList)
                        
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
                        .padding(32)
                        .padding(.bottom, finalDialogPaddingBottom)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 2)) {
                                finalDialogPaddingBottom = 0
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            gameViewModel.currentStage.beeScene.physicsBody = SKPhysicsBody(edgeLoopFrom: CGPath(ellipseIn: gameViewModel.currentStage.rect, transform: .none))
            if gameViewModel.currentStageIndex > 1 {
                self.gameViewModel.isRadarOn = true
            }
        }
    }
}
