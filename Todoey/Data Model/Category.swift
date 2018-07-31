//
//  Category.swift
//  Todoey
//
//  Created by Darran Edmundson on 2018-07-29.
//  Copyright © 2018 EDM Studio Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    @objc dynamic var colour : String = "#FFFFFF"
        
}
