//
//  Movie+CoreDataClass.swift
//  MovieLibrary
//
//  Created by Felipe Israel on 29/09/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(Movie)
public class Movie: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case name, rating, image, format
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let userInfoContext = CodingUserInfoKey.codingUserKeyContext, let context = decoder.userInfo[userInfoContext] as? NSManagedObjectContext else {
            fatalError("Failed to get NSManagedObjectContext")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.rating = try container.decode(Int16.self, forKey: .rating)
        self.format = try container.decode(String.self, forKey: .format)
        
        if let imageName = try container.decodeIfPresent(String.self, forKey: .image), let image = UIImage(named: imageName), let imageData = image.pngData() {
            self.image = imageData
        }
    }
}
