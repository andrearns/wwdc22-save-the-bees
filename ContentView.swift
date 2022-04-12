import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var sceneManager = SceneManager()
    var spriteView: SpriteView?
    
    var body: some View {
        VStack {
            SpriteView(scene: sceneManager.beeScene)
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
}
