//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 15/04/22.
//

import SwiftUI

struct FinalView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        FinalView()
    }
}
