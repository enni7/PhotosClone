//
//  PhotosCloneApp.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import SwiftUI

@main
struct PhotosCloneApp: App {
    @StateObject var photoDatabase = PhotoDatabase()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(photoDatabase)
        }
    }
}
