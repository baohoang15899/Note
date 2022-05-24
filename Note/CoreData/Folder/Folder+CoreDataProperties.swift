//
//  Folder+CoreDataProperties.swift
//  Note
//
//  Created by Toi Nguyen on 23/05/2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var items: Int64

}
