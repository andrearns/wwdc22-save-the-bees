import SwiftUI

@main
struct MyApp: App {
    @ObservedObject var gameViewModel = GameViewModel(
        currentStage: StageBank.shared.stageList[0],
        beeScene: StageBank.shared.stageList[0].beeScene
    )
    
    var body: some Scene {
        WindowGroup {
            InitialView(gameViewModel: gameViewModel)
                .navigationViewStyle(.stack)
        }
    }
}
