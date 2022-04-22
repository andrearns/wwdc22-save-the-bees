//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 19/04/22.
//

import SwiftUI

struct TaskView: View {
    @Binding var dialog: Dialog
    var onTap: () -> ()
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("TASK")
                        .foregroundColor(Color.beeYellow)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .padding(.bottom, 1)
                    
                    Text(dialog.text)
                        .foregroundColor(Color.white)
                        .font(.system(size: 21, weight: .semibold, design: .rounded))
                }
                Spacer()
            }
            .padding(.vertical, 32)
            .padding(.leading, 64)
            .padding(.trailing, 32)
            .frame(maxWidth: .infinity)
            .background(Color.beeMidBrown)
            .cornerRadius(16)
            .padding(.leading, 32)
            
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color.beeMidBrown)
                        .frame(width: 60)
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 40)
                    if dialog.isDone != nil && dialog.isDone == true {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42)
                            .foregroundColor(Color.beeGrassGreen)
                    }
                }
                .shadow(color: Color.white.opacity(0.05), radius: 16, x: 8, y: 0)
                Spacer()
            }
            .padding(.leading, 8)
        }
        .padding()
        .frame(maxHeight: 200)
        .onTapGesture {
            onTap()
        }
    }
}
