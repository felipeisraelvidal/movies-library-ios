//
//  Movie+CoreDataProperties.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var format: String
    @NSManaged public var rating: Int16
    @NSManaged public var image: Data?

}

extension Movie : Identifiable {

}
