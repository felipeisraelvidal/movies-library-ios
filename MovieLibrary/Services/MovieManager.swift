//
//  MovieManager.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//

import Foundation
import CoreData

final class MovieManager: ObservableObject {
    @Published var movies = [Movie]()
    
    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Movie>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Movie.format, ascending: false),
            NSSortDescriptor(keyPath: \Movie.name, ascending: true)
        ]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        loadMovies()
    }
    
    private func loadMovies() {
        do {
            try fetchedResultsController.performFetch()
            movies = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
        }
    }
}
