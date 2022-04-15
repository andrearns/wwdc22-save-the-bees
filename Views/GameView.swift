import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var sceneManager = SceneManager()
    @State var showHint: Bool = true
    @State var dialogIndex = 0
    @State var isRadarOn: Bool = true
    @State var isDialogOn: Bool = false
    @State var isDangerous: Bool = false
    
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
                        dialogIndex += 1
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
