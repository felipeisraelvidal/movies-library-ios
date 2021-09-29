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
            List {
                ForEach(Array(manager.sections.keys.sorted(by: >)), id: \.self) { section in
                    Section(
                        header: Text(section)
                    ) {
                        ForEach(manager.sections[section] ?? [], id: \.id) { movie in
                            HStack(spacing: 16) {
                                movie.pngImage
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(movie.name)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    RatingView(movie: movie)
                                        .environmentObject(manager)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Movie Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset", action: manager.batchReset)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                MovieManager(
                    context: PersistenceManager.preview.container.viewContext
                )
            )
    }
}
