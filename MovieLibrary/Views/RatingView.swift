//
//  RatingView.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//

import SwiftUI

struct RatingView: View {
    @EnvironmentObject private var manager: MovieManager
    
    var movie: Movie
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(index < movie.rating ? .yellow : .gray)
                    .onTapGesture {
                        starTapped(rating: index + 1)
                    }
            }
        }
    }
    
    private func starTapped(rating: Int) {
        movie.rating = Int16(rating)
        manager.update(movie)
    }
}

struct RatingView_Previews: PreviewProvider {
    private static var movie: Movie = {
        let movie = Movie(context: PersistenceManager.preview.container.viewContext)
        movie.id = UUID()
        movie.name = "Harry Potter"
        movie.rating = 3
        return movie
    }()
    
    static var previews: some View {
        RatingView(movie: movie)
            .environmentObject(
                MovieManager(
                    context: PersistenceManager.preview.container.viewContext
                )
            )
            .previewLayout(.sizeThatFits)
    }
}
