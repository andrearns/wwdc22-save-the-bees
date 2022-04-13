//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 13/04/22.
//

import SwiftUI

struct DialogView: View {
    
    var dialog: Dialog
    
    var hexagonWidth: CGFloat {
        (UIImage(named: "brownHexagonSprite")?.size.width)!
    }
    var hexagonHeight: CGFloat {
        (UIImage(named: "brownHexagonSprite")?.size.height)!
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.beeBrown)
                    .padding(.leading, hexagonWidth * 0.5)
                    .frame(height: 219)
                    .padding(.top, 0.5)
                
                HStack {
                    ZStack {
                        Image("brownHexagonSprite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image("honeycombSprite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(dialog.speaker == .queenBee ? "queenBeeSprite" : "beeSprite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(60)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(dialog.speaker == .queenBee ? "QUEEN BEE" : "YOU")
                            .foregroundColor(Color.beeYellow)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding(.bottom)
                        
                        Text(dialog.text)
                            .lineLimit(2)
                            .foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.8)
                        
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
                        }
                    }
                    .padding(.vertical, 32)
                    .padding(.trailing, 32)
                    .frame(height: 220)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .padding()
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(
            dialog:
                Dialog(
                    type: .text,
                    speaker: .workerBee,
                    text: "Your hour has come, you must work for me. You must collect the nectar from the flowers to feed me."
                )
        )
    }
}
