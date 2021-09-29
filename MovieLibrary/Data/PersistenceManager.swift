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
    
    static var preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieLibrary")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
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
