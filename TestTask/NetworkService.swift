//
//  NetworkServic.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//

import Foundation
import UIKit
import Alamofire

enum ApiError : Error {
    case noData
}
class NetworkService {
    func fetchImage(completion: @escaping (Result<Coctail, Error>)  -> Void){
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic") else { return }
        AF.request(url, method: .get, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(Coctail.self, from: data)
                completion(.success(objects))
                
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
            }
        }
    }
}

