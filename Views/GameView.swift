import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var sceneManager = SceneManager()
    @State var dialogIndex = 0
    @State var isRadarOn: Bool = false
    @State var isDialogOn: Bool = true
    @State var isDangerous: Bool = false
    @State var showNextStage: Bool = false
    
    var spriteView: SpriteView?
    var radarWidth: CGFloat {
        return UIScreen.main.bounds.width / 4
    }
    
    var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: sceneManager.beeScene)
            }
            VStack {
                Spacer()
                DialogView(dialog: sceneManager.currentStage.dialogList[dialogIndex])
                    .opacity(isDialogOn ? 1 : 0)
                    .onTapGesture {
                        if dialogIndex < sceneManager.currentStage.dialogList.count - 1 {
                            dialogIndex += 1
                        } else {
                            dialogIndex = 0
                            sceneManager.currentStageIndex += 1
                            showNextStage = true
                        }
                    }
                NavigationLink("", isActive: $showNextStage) {
                    StageIntroView(title: "Stage 2", description: "Entering the danger zone")
                }
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
