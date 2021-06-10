//
//  Home.swift
//  UI-231
//
//  Created by にゃんにゃん丸 on 2021/06/10.
//

import SwiftUI

struct Home: View {
    
    @State var onFinish = false
    var body: some View {
        VStack{
            
            ScratchCardView(customSize:70,onFinsh : $onFinish) {
                
                VStack{
                    
                    
                    Image("p1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.cornerRadius(10)
                        .padding(10)
                    
                    Text("Tokyo Tower")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Night Tower")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.primary)
                        .padding(.top,5)
                    
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                
            } overlayView: {
                
                Image("p2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    //.padding(10)
            }

            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .overlay(
        
        
            HStack{
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "line.3.crossed.swirl.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                })
                    
                    
                    Spacer(minLength: 0)
                    
                Button(action: {
                    
                    withAnimation{
                        
                        
                        onFinish = false
                    }
                    
                }, label: {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.white)
                    
                    
                    
                    
                })
                
                
            }
            .overlay(
            
            Text("SCRATCH")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            )
            
            ,alignment: .top
        
        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct ScratchCardView<Content : View,OverlayView : View> : View {
    
    var content : Content
    var overlayView : OverlayView
    
    
    init(customSize: CGFloat,onFinsh : Binding<Bool>, @ViewBuilder content : @escaping()->Content,@ViewBuilder overlayView : @escaping()->OverlayView) {
        self.content = content()
        self.overlayView = overlayView()
        self.customSize = customSize
        self._onFinsh = onFinsh
    }
    @State var startPoints : CGPoint = .zero
    
    
    @State var points : [CGPoint] = []
    
    @GestureState var gestureLocation : CGPoint = .zero
    
    var customSize : CGFloat
    
    @Binding var onFinsh : Bool

    
    var body: some View{
        
        ZStack{
            
            
            overlayView
                .opacity(onFinsh ? 0 : 1)
            
            content
                .mask(
                
                
                    ZStack{
                        
                        
                        if !onFinsh{
                            
                            CustomShape(points: points, startpoint: startPoints)
                                .stroke(style: StrokeStyle(lineWidth: customSize, lineCap: .round, lineJoin: .round))
                            
                            
                        }
                        
                        else{
                            
                            Rectangle()
                            
                            
                        }
                        
                    }
                
                )
                .animation(.easeInOut)
      
        .gesture(
            
        
        
            DragGesture().updating($gestureLocation, body: { value, out, _ in
                out = value.location
                DispatchQueue.main.async {
                    
                    if startPoints == .zero{
                        
                        startPoints = value.location
                        
                        
                       
                        
                    }
                    
                    points.append(value.location)
                    
                    print(points)
                    
                    
                    
                }
                
                
            }).onEnded({ value in
            
                withAnimation{
                    
                    onFinsh = true
                }
                
                
            })
        )
        
            
            
        }
        .frame(width: 300, height: 300)
        .cornerRadius(20)
        .onChange(of: onFinsh, perform: { value in
            
            
            if !onFinsh && !points.isEmpty{
                
                withAnimation(.easeInOut){
                    
                    
                    ResetView()
                    
                }
                
                
            }
            
        })
        
        
    }
    
    func ResetView(){
        
       
        points.removeAll()
        startPoints = .zero
        
    }
}

struct CustomShape : Shape {
    var points : [CGPoint]
    
    var startpoint : CGPoint
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
            path.move(to: startpoint)
            path.addLines(points)
            
            
        }
    }
    
}

