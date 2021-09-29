//
//  PersistenceManager.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//

import Foundation
import CoreData

struct PersistenceManager {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MovieLibrary")
        container.loadPersistentStores { store, error in
            if let error = error as NSError? {
                fatalError("Error load \(store): \(error.localizedDescription)")
            }
        }
        
        checkData()
    }
    
    private func checkData() {
        let context = container.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        if let movieCount = try? context.count(for: request), movieCount > 0 {
            return
        }
        
        uploadSampleData()
    }
    
    private func uploadSampleData() {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"), let data = try? Data(contentsOf: url), let codingUserKeyContext = CodingUserInfoKey.codingUserKeyContext else { return }
        
        do {
            let context = container.viewContext
            let decoder = JSONDecoder()
            
            decoder.userInfo[codingUserKeyContext] = context
            _ = try decoder.decode([Movie].self, from: data)
            
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
