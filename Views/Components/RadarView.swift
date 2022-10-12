//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 20/04/22.
//


// REMEMBER TO REMOVE THIS
import SwiftUI

struct RadarView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var radarViewModel: RadarViewModel
    
    var width: CGFloat
    var openFlowersPositionList: [CGPoint]
    
    init(width: CGFloat, openFlowersPositionList: [CGPoint], gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        self.width = width
        self.openFlowersPositionList = openFlowersPositionList
        self.radarViewModel = RadarViewModel(beeScene: gameViewModel.beeScene, width: width)
    }
    
    var body: some View {
        ZStack {
            Image(radarViewModel.isDangerous ? "dangerRadarSprite" : "radarFrameSprite")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ForEach(openFlowersPositionList, id: \.self) { openFlowerPosition in
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .frame(width: width/2, height: 10)
                        Circle()
                            .foregroundColor(Color.beeRed)
                            .frame(width: 30)
                            .opacity(radarViewModel.showFlower(flowerRealPosition: openFlowerPosition) ? 1 : 0)
                            .padding(.leading, radarViewModel.getGraphDistance(flowerPosition: openFlowerPosition) - 15)
                        Spacer()
                    }
                }
                .rotationEffect(Angle(radians: radarViewModel.getAngle(flowerPosition: openFlowerPosition)))
            }
            
            Circle()
                .foregroundColor(Color.beeBlueSky)
                .frame(width: 30)
        }
        .frame(width: width, height: width)
        .padding(.horizontal)
        .padding(.top)
    }
}
