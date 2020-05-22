//
//  SctionModel.swift
//  Channels
//
//  Created by Ahmed Refaat on 4/15/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import Foundation

struct Section<T: Hashable, U: Hashable>: Hashable {
    let headerItem: T
    let sectionItems: U
}

struct DataSource<T: Hashable> {
    let sections: [T]
}

class MovieSection: Hashable {
    
    var sectionTitle: String = "Popular Movies"
    
    var media: [Movie]?
    
    init(media: [Movie]) {
        self.media = media
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MovieSection, rhs: MovieSection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}

class CategoreySection: Hashable {
    
    var sectionTitle: String = "Categories"
    
    var categories: [Categorey]?
    
    init(categories: [Categorey]) {
        self.categories = categories
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: CategoreySection, rhs: CategoreySection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}
