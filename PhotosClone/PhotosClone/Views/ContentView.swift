//
//  ContentView.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var photoDatabase: PhotoDatabase
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "photo.fill.on.rectangle.fill")
                }
            Text("")
                .tabItem {
                    Label("For You", systemImage: "heart.text.square.fill")
                }
            Text("")
                .tabItem {
                    Label("Albums", systemImage: "rectangle.stack.fill")
                }
            Text("")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotoDatabase())
    }
}
