//
//  ImageView.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var photoDatabase: PhotoDatabase
    
    @State var photo: Photo
    
    @GestureState var zoomScaleAmount = 1.0
    @State var scale = 1.0
    @State var tryingToClose = false
    
    var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomScaleAmount) { value, state, transaction in
                state = value
            } .onEnded { value in
                scale *= value
                if scale > 5 {
                    scale = 5
                } else if scale < 1 {
                    scale = 1
                    tryingToClose = true
                }
            }
    }
    @GestureState var rotationAngleAmount = Angle.zero
    @State var angle = Angle.zero
    
    var rotationGesture : some Gesture {
        RotationGesture()
            .updating($rotationAngleAmount) { value, state, _ in
                state = value
            } .onEnded { value in
                withAnimation {
                    if value.degrees < -60 {
                        angle += Angle(degrees: -90)
                    } else if value.degrees > 60 {
                        angle += Angle(degrees: 90)
                    }
                }
            }
    }
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: scale == 1 ? .infinity : 0, coordinateSpace: .global)
            .onChanged{ value in
                draggedAmount = value.translation
            }.onEnded { value in
                drag.width += draggedAmount.width
                drag.height += draggedAmount.height
                
                let offsetWidthMax = ((UIScreen.main.bounds.maxX * scale - UIScreen.main.bounds.maxX) / scale) / 2
                let dragScaled = CGSize(width: drag.width * scale, height: drag.height * scale)
                
                withAnimation {
                    if dragScaled.width > offsetWidthMax {
                        drag.width = offsetWidthMax
                    } else if drag.width * scale < -offsetWidthMax {
                        drag.width = -offsetWidthMax }
                    
                    let offsetHeightMax = (UIScreen.main.bounds.size.height * scale - UIScreen.main.bounds.size.height) / 2
                    if drag.height > offsetHeightMax {
                        drag.height = offsetHeightMax
                    } else if drag.height < -offsetHeightMax {
                        drag.height = -offsetHeightMax }
                }
                draggedAmount = CGSize.zero
            }
    }
    
    @State var doubleTappedPoint = UnitPoint(x: 0, y: 0)
    @State var doubleTapped = false
    @State var draggedAmount = CGSize.zero
    @State var drag = CGSize(width: 0, height: 0)
    var body: some View {
        Image(uiImage: photo.image)
            .resizable()
            .scaledToFit()
            .offset(x: drag.width + draggedAmount.width, y: drag.height + draggedAmount.height)
            .rotationEffect(angle + rotationAngleAmount)
            .scaleEffect(scale * zoomScaleAmount)
            .gesture(zoomGesture
                        .simultaneously(with: rotationGesture)
                        .simultaneously(with: dragGesture)
                        .simultaneously(with: TapGesture(count: 2)
                                            .onEnded{
                    doubleTapped = !doubleTapped
                withAnimation {
                    if scale != 1 {
                        drag = CGSize(width: 0, height: 0)
                        scale = 1
                    } else {
                        scale = 2
                    }
                }
            }))
    }
}


struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: PhotoDatabase().photos[11])
            .environmentObject(PhotoDatabase())
    }
}
