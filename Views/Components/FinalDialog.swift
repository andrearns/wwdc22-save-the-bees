//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 20/04/22.
//

import SwiftUI

struct FinalDialog: View {
    var body: some View {
        VStack {
            Text("CONGRATULATIONS!")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(Color.beeYellow)
                .padding(.top)
                .padding(.horizontal)
            
            Text("Did you see how many flowers a bee can pollinate? Bees are very important agents for the maintenance of our nature and they pollinate 80% of all flowering plants in the world. This means that the apple and chocolate we eat and the cotton t-shirt we wear depend directly on the life of the bees. \n \n Currently they are in great danger due to the excessive use of pesticides, which cause them to lose their nests and in many cases end up dying. Pesticides affect the navigation system of bees and cause them to get lost from their hives. This phenomenon is called CCD (Colony Collapse Disorder), which has been studied in the recent years by scientists. In the United States, it is estimated that in the past half century there was a loss of 50% of the bee population due to the use of fipronil and neonicotinoids. \n\nIn other words, bees are very valuable for the maintenance of life on Earth and it seems that they are not valued enough. Share your today learning with other people and #SaveTheBees")
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: getFontSize(), weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
        }
        .padding()
        .background(Color.beeMidBrown)
        .cornerRadius(16)
        .padding()
    }
    
    func getFontSize() -> CGFloat {
        if UIScreen.main.bounds.width < 1000 {
            return 18
        }
        else {
            return 21
        }
    }
}

struct FinalDialog_Previews: PreviewProvider {
    static var previews: some View {
        FinalDialog()
    }
}
