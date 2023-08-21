//
//  CameraView.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 08/08/23.
//

import SwiftUI

struct CameraView: View {
    let cameraRepresentable : CameraViewRepresentable = CameraViewRepresentable()
    @State var isGhostCaptured : Bool = false
    
    var body: some View {
        GeometryReader { screenSize in
            ZStack {
                cameraRepresentable.ignoresSafeArea()
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                    .frame(width: screenSize.size.width, height: screenSize.size.height)
                    .opacity(0.5)
                
                VStack {
                    HStack {
                        Button {
                            
                        } label: {
                            Image("exit-button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                        }
                        
                        Spacer()
                        
                        Image("baterai")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("color-meter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                        Spacer()
                        
                        Image("crosshair")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("health")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                        Spacer()
                        Image("position-meter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                    }
                }.padding(60)
                
                if screenSize.size.width < screenSize.size.height {
                    VStack {
                        Spacer()
                        Button {
                            cameraRepresentable.pickPhotoGhost()
                        } label: {
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.clear)
                                .overlay {
                                    Circle()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                }
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Button {
                            cameraRepresentable.pickPhotoGhost()
                        } label: {
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.clear)
                                .overlay {
                                    Circle()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                }
                        }
                    }
                }
            }
            .onAppear {
                subscribeVariable()
            }
        }
    }
    
    private func subscribeVariable() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !isGhostCaptured && cameraRepresentable.cameraController.isCaptured != isGhostCaptured {
                isGhostCaptured = cameraRepresentable.cameraController.isCaptured
                print(isGhostCaptured)
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
