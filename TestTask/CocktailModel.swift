//
//  ModelCocktail.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//
import Foundation

// MARK: - Coctail
struct Coctail: Codable {
    let drinks: [Drink]
}
// MARK: - Drink
struct Drink: Codable {
    let strDrink: String
}
