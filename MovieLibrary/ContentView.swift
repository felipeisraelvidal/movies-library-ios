//
//  ContentView.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 28/09/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var manager: MovieManager
    
    var body: some View {
        NavigationView {
            List(manager.movies, id: \.id) { movie in
                Text(movie.name)
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Movie Library")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
