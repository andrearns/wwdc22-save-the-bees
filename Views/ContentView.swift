import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var sceneManager = SceneManager()
    @State var showHint: Bool = true
    @State var dialogIndex = 0
    
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
                    .onTapGesture {
                        dialogIndex += 1
                    }
            }
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .foregroundColor(Color.black)
                            .frame(width: radarWidth, height: radarWidth)
                            .padding()
                        Text("Radar")
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
}
