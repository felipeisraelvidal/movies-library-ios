//
//  MovieManager.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//

import Foundation
import CoreData

final class MovieManager: NSObject, ObservableObject {
    @Published var movies = [Movie]()
    @Published var sections = [String : [Movie]]()
    
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
            sectionNameKeyPath: #keyPath(Movie.format),
            cacheName: "moviesList"
        )
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        
        loadMovies()
    }
    
    private func loadMovies() {
        do {
            try fetchedResultsController.performFetch()
            
            if let sections = fetchedResultsController.sections, !sections.isEmpty {
                for section in sections {
                    if let movies = section.objects as? [Movie] {
                        self.sections[section.name] = movies
                    }
                }
            }
            
            movies = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error saving data: \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ movie: Movie) {
        save()
    }
    
    func resetRating() {
        for movie in movies {
            movie.rating = 0
        }
        
        save()
    }
    
    func batchReset() {
        let request = NSBatchUpdateRequest(entityName: "Movie")
        request.propertiesToUpdate = [
            #keyPath(Movie.rating) : 0
        ]
        
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        
        do {
            let batchResult = try context.execute(request) as? NSBatchUpdateResult
            print("Batch update: \(batchResult?.result ?? 0)")
            
            context.reset()
            loadMovies()
        } catch {
            print("Error ratings batch update: \(error.localizedDescription)")
        }
    }
}

extension MovieManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let updatedMovies = controller.fetchedObjects as? [Movie] else { return }
        
        self.movies = updatedMovies
    }
}
