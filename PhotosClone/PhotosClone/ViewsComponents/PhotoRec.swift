//
//  PhotoRec.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct PhotoRec: View {
    
    @EnvironmentObject var photoDatabase: PhotoDatabase
    @State var aspectRatio: CGFloat
    @State var photo: Photo
    
    var body: some View {
        ZStack{
            Rectangle()
            .aspectRatio(aspectRatio, contentMode: .fit)
                .overlay {
                    Image(uiImage: photo.image)
                        .resizable()
                        .scaledToFill()
                }
                .clipShape(Rectangle())
        }
    }
}

struct PhotoRec_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRec(aspectRatio: 1, photo: PhotoDatabase().photos[11])
            .environmentObject(PhotoDatabase())
    }
}
