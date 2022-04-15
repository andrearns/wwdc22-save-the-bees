//
//  SwiftUIView.swift
//  
//
//  Created by André Arns on 14/04/22.
//

import SwiftUI

struct InitialView: View {
    @State var tapOpacity: Double = 0
    @State var firstCloudXPosition: CGFloat = -300
    @State var secondCloudXPosition: CGFloat = 300
    @State var thirdCloudXPosition: CGFloat = -500
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.beeBlueSky)
                    .frame(maxHeight: UIScreen.main.bounds.height)
                
                // First cloud
                VStack {
                    Image("cloudSprite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                        .offset(x: secondCloudXPosition)
                        .animation(Animation.easeInOut(duration: 40).repeatForever(autoreverses: true).speed(1.3))
                        .onAppear {
                            secondCloudXPosition -= UIScreen.main.bounds.width
                        }
                        .padding(.top, 0)
                    Spacer()
                }
                
                // Second cloud
                VStack {
                    Image("cloudSprite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .offset(x: firstCloudXPosition)
                        .animation(Animation.easeInOut(duration: 40).repeatForever(autoreverses: true).speed(1))
                        .onAppear {
                            firstCloudXPosition += UIScreen.main.bounds.width
                        }
                        .padding(.top, 180)
                    Spacer()
                }
                
                // Third cloud
                VStack {
                    Image("cloudSprite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .offset(x: thirdCloudXPosition)
                        .animation(Animation.easeInOut(duration: 40).repeatForever(autoreverses: true).speed(1.6))
                        .onAppear {
                            thirdCloudXPosition += UIScreen.main.bounds.width
                        }
                        .padding(.top, 400)
                    Spacer()
                }
            }
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color.beeGrassGreen)
                    .frame(maxHeight: UIScreen.main.bounds.height / 3)
                    .padding(0)
            }
            VStack {
                Image("hiveTreeSprite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: (UIScreen.main.bounds.height * 3) / 5)
                    .padding(.top, 64)
                
                Text("TAP TO START")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(Color.beeBrown)
                    .padding(.top, 64)
                    .opacity(tapOpacity)
                // Review
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            print("Start game")
        }
        .onAppear {
            tapOpacity = 1
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
