//
//  Item.swift
//  Todoey
//
//  Created by Darran Edmundson on 2018-07-29.
//  Copyright © 2018 EDM Studio Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
