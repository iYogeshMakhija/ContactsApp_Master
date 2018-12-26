//
//  CountryQueryService.swift
//  Contacts app
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array of Country
class CountryQueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Country]?, String) -> ()
    typealias ArrayOfJSONDictionary = [[String:Any]]
    
    var errorMessage = ""
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var countryResult: ArrayOfJSONDictionary = []
    var countries: [Country] = []
    
    func getCountries(completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://restcountries.eu/rest/v1/all") {
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateSearchResults(data)
                    DispatchQueue.main.async {
                        completion(self.countries, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: ArrayOfJSONDictionary?
        countries.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? ArrayOfJSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response as? [[String:Any]] else {
            errorMessage += "Array does not contain Country results key\n"
            return
        }
        var index = 0
        for countryDictionary in array {
            if let countryDictionary = countryDictionary as? JSONDictionary,
                let countryName = countryDictionary["name"] as? String,
                let countryCode = countryDictionary["callingCodes"] as? [String]{
                countries.append(Country(countryName: countryName, countryCode: countryCode.count > 0 ? countryCode[0] : "" ))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
}
