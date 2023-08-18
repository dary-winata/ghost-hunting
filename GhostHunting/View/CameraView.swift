//
//  CameraView.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 08/08/23.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        GeometryReader { screenSize in
            ZStack {
                CameraViewRepresentable().ignoresSafeArea()
                VStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.clear)
                            .overlay {
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
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
