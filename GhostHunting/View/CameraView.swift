//
//  CameraView.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 08/08/23.
//

import SwiftUI

struct CameraView: View {
    var cameraRepresentable : CameraViewRepresentable = CameraViewRepresentable()
    
    var body: some View {
        GeometryReader { screenSize in
            ZStack {
                cameraRepresentable.ignoresSafeArea()
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
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
