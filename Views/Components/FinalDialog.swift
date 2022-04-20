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
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color.beeYellow)
                .padding(.top)
                .padding(.horizontal)
            
            Text("CHANGE THIS TEXT!!! You must  work for me, you lazy. You must collect the nectar from the flowers to feed me.  You must  work for me, you lazy. You must collect the nectar from the flowers to feed me. You must  work for me, you lazy. You must collect the nectar from the flowers to feed me. You must  work for me, you lazy. You must collect the nectar from the flowers to feed me. You must collect the nectar from the flowers to feed me. You must  work for me, you lazy. You must collect the nectar from the flowers to feed me.")
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
        }
        .padding()
        .background(Color.beeMidBrown)
        .cornerRadius(16)
        .padding()
    }
}

struct FinalDialog_Previews: PreviewProvider {
    static var previews: some View {
        FinalDialog()
    }
}
