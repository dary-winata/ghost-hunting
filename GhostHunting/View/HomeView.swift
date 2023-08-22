import SwiftUI

struct HomeView: View {
    @State private var rotationAngle: Double = 0
    @State private var orientation : String = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { screenSize in
                ZStack() {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.size.width)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Text("23:59")
                                .font(Font.custom("SF Pro", size: 35))
                                .foregroundColor(.white)
                            Text("Mon Oct 31")
                                .font(Font.custom("SF Pro", size: 35))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "wifi")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Image(systemName: "battery.100")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }.padding(.horizontal, 30)
                            .padding(.top, 15)
                        
                        if screenSize.size.width < screenSize.size.height {
                            HStack {
                                Spacer()
                                Image("windmill")
                                    .resizable()
                                    .rotationEffect(.degrees(rotationAngle))
                                    .frame(width: 200, height: 200)
                                    .onAppear {
                                        withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                                            rotationAngle = 360
                                            
                                        }
                                    }
                                    .onRotate { _ in
                                        withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                                            rotationAngle = 360
                                        }
                                    }
                            }.padding(.top, 100)
                                .padding(.trailing, -50)
                            
                            Spacer()
                                .frame(height: 250)
                        } else {
                            HStack {
                                Spacer()
                                Image("windmill")
                                    .resizable()
                                    .rotationEffect(.degrees(rotationAngle))
                                    .frame(width: 200, height: 200)
                                    .onAppear {
                                        withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                                            rotationAngle = 360
                                        }
                                    }
                                    .onRotate { _ in
                                        withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                                            rotationAngle = 360
                                        }
                                    }
                            }
                            .padding(.top, 30)
                            .padding(.trailing, 240)
                            
                            Spacer()
                                .frame(height: 200)
                        }
                        
                        VStack {
                            HStack{
                                VStack {
                                    NavigationLink {
                                        CameraView()
                                    } label: {
                                        Image("camera")
                                            .resizable()
                                            .frame(width: 200, height: 200)
                                    }

                                    Text("Ghost Hunt")
                                        .bold()
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                }.padding(.trailing, 50)
                                
                                VStack {
                                    Button(action:{
                                    }, label: {
                                        Image("pokedex")
                                            .resizable()
                                            .frame(width: 200, height: 200)
                                    })
                                    Text("Collection")
                                        .bold()
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .statusBarHidden(true)        }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
