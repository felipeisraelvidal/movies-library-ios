//
//  MovieLibraryApp.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 28/09/21.
//

import SwiftUI

@main
struct MovieLibraryApp: App {
    let movieManager = MovieManager(context: PersistenceManager().container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieManager)
        }
    }
}
