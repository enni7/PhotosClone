//
//  LibraryView.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct LibraryView: View {
    
    init(){
        let navBarStandardArrearance = UINavigationBarAppearance()
        let navBarscrollEdgeArrearance = UINavigationBarAppearance()
        
        navBarscrollEdgeArrearance.configureWithTransparentBackground()
        navBarStandardArrearance.configureWithTransparentBackground()
        navBarStandardArrearance.backgroundImage = UIImage(named: "gradientBlack")
        navBarStandardArrearance.backgroundImageContentMode = .scaleAspectFill
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarscrollEdgeArrearance
        UINavigationBar.appearance().standardAppearance = navBarStandardArrearance
    }
    
    @EnvironmentObject private var photoDatabase: PhotoDatabase
    @State private var showPhoto = false
    @State var currIndex : Int = 0

    @State private var scrolledBar = false
    @State private var minimunColumnWidth = 120.0
    @State private var scale = 1.0
    @GestureState private var pinchAmount = 1.0
    var columns : [GridItem] {
        let col = [GridItem(.adaptive(minimum: minimunColumnWidth), spacing: 4)]
        return col
    }
    
    var pinchGesture : some Gesture {
        MagnificationGesture()
            .onChanged{ value in
                scale = value
                let scaledMaxWidth = minimunColumnWidth * scale
                var newMin : CGFloat {
                    if scale < 1 {
                        return (scaledMaxWidth > 90 ? 120 : 70)
                    } else {
                        return (scaledMaxWidth < 220 ? 120 : 300)
                    }
                }
                minimunColumnWidth = newMin
            }
            .onEnded { value in
                scale = 1.0
            }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView{
                    LazyVGrid (columns: columns, spacing: 4) {
                        ForEach(photoDatabase.photos) { photo in
                            PhotoRec(aspectRatio: 1, photo: photo)
                                .id(photo.id)
                                .onTapGesture {
                                    currIndex = photoDatabase.indexForPhoto(photo: photo)
                                    showPhoto.toggle()
                                }
                                }
                        }.background {
                            GeometryReader {geo in
                                Color.clear.opacity(0)
                                    .onChange(of: geo.frame(in: .named("scroll")).minY) { newVal in
                                        scrolledBar = (newVal >= 0 ? false : true)
                                        let modulus = abs(newVal).remainder(dividingBy: minimunColumnWidth + 4)
                                        if modulus >= 0 && modulus <= 1  {
                                            currIndex = photoDatabase.scrolledCurrentPhotoIndex(offset: newVal, colWidth: minimunColumnWidth)
                                        }
                                    }
                            }
                    }
                }.coordinateSpace(name: "scroll")
            }
            .scaleEffect(scale)
                .gesture(pinchGesture)
            .fullScreenCover(isPresented: $showPhoto) {
                OpenedPhotoView(currIndex: currIndex)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(photoDatabase.photos[currIndex].dateFormattedDayMonth())
                        .font(.title)
                        .fontWeight(.bold)
                        .shadow(color: .black, radius: scrolledBar ? 5 : 0)
                        .foregroundColor(scrolledBar ? .white : .primary)
                }
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(PhotoDatabase())
    }
}
