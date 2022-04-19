//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 19/04/22.
//

import SwiftUI

struct FlowerGoalView: View {
    @Binding var currentCount: Int
    var goal: Int
    var maxWidth: CGFloat
    
    var body: some View {
        HStack {
            Image("redFlowerSprite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
            
            Text("\(currentCount)/\(goal)")
                .foregroundColor(Color.white)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.leading)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .padding(.horizontal, 8)
        .background(Color.beeMidBrown)
        .cornerRadius(16)
        .frame(maxWidth: maxWidth)
    }
}

//struct FlowerGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowerGoalView(currentCount: 4, goal: 10, maxWidth: 200)
//    }
//}
