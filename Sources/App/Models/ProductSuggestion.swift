//
//  ProductSuggestion.swift
//  
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Vapor

struct ProductSuggestion: Content {
    var name: String
    var stores: [Store]
    var types: [String]
    var sizes: [String]
}
