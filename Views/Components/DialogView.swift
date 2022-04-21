//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import SwiftUI

struct DialogView: View {
    
    @Binding var dialog: Dialog
    @State var nextOpacity: Double = 0
    
    var hexagonWidth: CGFloat {
        (UIImage(named: "brownHexagonSprite")?.size.width)!
    }
    var hexagonHeight: CGFloat {
        (UIImage(named: "brownHexagonSprite")?.size.height)!
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.beeMidBrown)
                    .padding(.leading, hexagonWidth * 0.5)
                    .padding(.top, 1.25)
                
                HStack {
                    ZStack {
                        Image("brownHexagonSprite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        ZStack {
                            Image("honeycombSprite")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(-20)
                            Image(dialog.speaker == .queenBee ? "queenBeeSprite" : "beeSprite")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(60)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(dialog.speaker == .queenBee ? "MOMMY - QUEEN BEE" : "YOU - WORKERBEE")
                            .foregroundColor(Color.beeYellow)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.bottom)
                        
                        Text(dialog.text)
                            .lineLimit(2)
                            .foregroundColor(Color.white)
                            .font(.system(size: 21, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                        
                        if dialog.type == .text {
                            HStack {
                                Spacer()
                                HStack {
                                    Text("NEXT")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(Color.beeYellow)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            }
                            .padding(.top)
                            .opacity(nextOpacity)
                            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: nextOpacity)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.trailing, 32)
                    .frame(height: 220)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .padding()
        .onAppear{
            nextOpacity = 1
        }
    }
}
