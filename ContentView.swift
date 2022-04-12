import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var sceneManager = SceneManager()
    @State var showHint: Bool = true
    
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
                VStack {
                    Text("Use o acelerômetro do celular para controlar a velocidade e direção da abelha")
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .background(Color.black)
                .cornerRadius(16)
                .padding()
                .opacity(showHint ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        showHint = false
                    }
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
