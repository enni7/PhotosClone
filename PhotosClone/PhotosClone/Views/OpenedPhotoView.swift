//
//  OpenedPhotoView.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct OpenedPhotoView: View {
    @EnvironmentObject  var photoDatabase: PhotoDatabase
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fullScreen = false
    @State var currIndex: Int
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.black
                    .opacity(fullScreen ? 1 : 0)
                    .ignoresSafeArea()
                TabView(selection: $currIndex) {
                    ForEach(0..<photoDatabase.photos.count, id: \.self) {indx in
                        ImageView(photo: photoDatabase.photos[indx])
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)) {
                                    fullScreen.toggle()
                                }
                            }
                            .tag(indx)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !fullScreen {
                ScrollingPhotosPreviews(currIndex: $currIndex)
                    .frame(maxHeight: 50)
                    .padding(.top, 2)
                    .opacity(fullScreen ? 0 : 1)
                    .transition(.opacity)
                }
                    
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarHidden(fullScreen)
            .navigationBarTitleDisplayMode(.inline)
            .statusBar(hidden: fullScreen)
            
            //Navigation Bar
            .toolbar{
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(photoDatabase.photos[currIndex].dateFormattedMonthDay())
                            .frame(maxWidth: .infinity)
                            .font(.footnote.weight(.medium))
                        Text(photoDatabase.photos[currIndex].date.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        //
                    }
                }
            }
            
            //Bottom toolbar
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar){
                    if !fullScreen {
                        HStack{
                            Button {
                                //
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            Spacer()
                            Button {
                                photoDatabase.photos[currIndex].isFavorite.toggle()

                            } label: {
                                Image(systemName: photoDatabase.photos[currIndex].isFavorite ? "heart.fill" : "heart").animation(.linear)
                            }
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct OpenedPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        OpenedPhotoView(currIndex: 20)
            .environmentObject(PhotoDatabase())
    }
}
