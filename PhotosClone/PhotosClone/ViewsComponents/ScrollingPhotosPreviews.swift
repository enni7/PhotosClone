//
//  ScrollingPhotosPreviews.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct ScrollingPhotosPreviews: View {
    @EnvironmentObject  var photoDatabase: PhotoDatabase
    
    @Binding var currIndex: Int
    
    var body: some View {
        ScrollViewReader { scroll in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2){
                    Spacer(minLength: 200)
                    ForEach(photoDatabase.photos) { photoo in
                        //if currIndex == photoDatabase.indexForPhoto(photo: photoo) -> original aspect
                        PhotoRec(aspectRatio: 0.50, index: photoDatabase.indexForPhoto(photo: photoo))
                            .id(photoDatabase.indexForPhoto(photo: photoo))
                            .onTapGesture {
                                currIndex = photoDatabase.indexForPhoto(photo: photoo)
                                scroll.scrollTo(currIndex, anchor: .center)
                            }
                            .overlay{
                                GeometryReader {geo in
                                    Rectangle()
                                        .opacity(0)
                                        .onChange(of: geo.frame(in: .global)) { newValue in
                                            //if it's in the middle frame
                                            if (newValue.midX >= (( UIScreen.main.bounds.width - newValue.width) / 2)) && (newValue.midX <= ((UIScreen.main.bounds.width + newValue.width) / 2)) {
                                                if currIndex != photoDatabase.indexForPhoto(photo: photoo) {
                                                    currIndex = photoDatabase.indexForPhoto(photo: photoo)
                                                }
                                            }
                                        }
                                }
                            }
                    }
                    Spacer(minLength: 200)
                }
            }
            .onChange(of: currIndex, perform: { new in
                withAnimation(.default) {
                    scroll.scrollTo(new, anchor: .center)
                }
            })
            .onAppear {
                withAnimation {
                    scroll.scrollTo(currIndex, anchor: .center)
                }
            }
        }
    }
}

struct ScrollingPhotosPreviews_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingPhotosPreviews(currIndex: .constant(24))
            .environmentObject(PhotoDatabase())
    }
}
