//
//  Recipe.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import Foundation

struct RecipeResponse: Codable {
    let meals: [Recipe]?
}

struct Recipe: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    
    var id: String {
        idMeal
    }
}
