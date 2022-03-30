//
//  CocktailViewModel.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//

import Foundation
import UIKit
import TTGTags

protocol ICocktailPresenter: AnyObject {
    func didLoadView(vc: ViewController)
    func drinksArray() -> [Drink]
    func show()
    var coctail: [Drink] { get set }
}

class CocktailPresenter: ICocktailPresenter {
    var networkService = NetworkService()
    var coctail = [Drink]()
    private weak var vc: ViewController?
    
    func didLoadView(vc: ViewController) {
        self.vc = vc
        self.vc?.drinksArrayHandler = { [weak self] in
            return self?.drinksArray() ?? [Drink]()
        }
    }
    
    func drinksArray() -> [Drink] {
        return coctail
    }
    
    func show() {
        parseJson()
    }
    
   private func parseJson() {
        self.networkService.fetchImage { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let drink):
                    self?.coctail = drink.drinks
                    self?.vc?.update()
                case.failure:
                    print("error")
                }
            }
        }
    }
}
