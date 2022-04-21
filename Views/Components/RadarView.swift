//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 20/04/22.
//

import SwiftUI

struct RadarView: View {
    @ObservedObject var gameViewModel: GameViewModel
    var width: CGFloat
    var isDangerous: Bool
    var openFlowersPositionList: [CGPoint]
    
    var body: some View {
        ZStack {
            Image(isDangerous ? "dangerRadarSprite" : "radarFrameSprite")
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
                            .opacity(showFlower(flowerRealPosition: openFlowerPosition) ? 1 : 0)
                            .padding(.leading, getGraphDistance(flowerPosition: openFlowerPosition) - 15)
                        Spacer()
                    }
                }
                .rotationEffect(Angle(radians: getAngle(flowerPosition: openFlowerPosition)))
            }
            
            Circle()
                .foregroundColor(Color.beeBlueSky)
                .frame(width: 30)
        }
        .frame(width: width, height: width)
        .padding(.horizontal)
        .padding(.top)
    }
    
    func showFlower(flowerRealPosition: CGPoint) -> Bool {
        let realDistance = getRealDistance(flowerPosition: flowerRealPosition)
        if realDistance > 640 {
            return false
        } else {
            return true
        }
    }
    
    func getRealDistance(flowerPosition: CGPoint) -> CGFloat {
        if let bee = gameViewModel.beeScene.bee {
            let a = bee.position.y - flowerPosition.y
            let b = bee.position.x - flowerPosition.x
            let distance = sqrt(pow(a, 2) + pow(b, 2))
            return distance
        }
        return 0
    }
    
    func getGraphDistance(flowerPosition: CGPoint) -> CGFloat {
        let realDistance = getRealDistance(flowerPosition: flowerPosition)
        let proportionalDistance = (realDistance * width)/1280
        return proportionalDistance
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }

    func getAngle(flowerPosition : CGPoint) -> CGFloat {
        if let bee = gameViewModel.beeScene.bee {
            let y = bee.position.y - flowerPosition.y
            let hip = getRealDistance(flowerPosition: flowerPosition)
            let sin = y/hip
            let arcsen = asin(sin)
            return arcsen
        }
        return 0
    }
}

//struct RadarView_Previews: PreviewProvider {
//    static var previews: some View {
//        RadarView(
//            width: 320,
//            isDangerous: false,
//            beePosition: CGPoint(x: 0, y: 0),
//            openFlowersPositionList: [
//                CGPoint(x: 0, y: 0)
//            ]
//        )
//    }
//}
