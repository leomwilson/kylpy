//
//  jsonWebVM.swift
//  kylpypt2
//
//  Created by Leo Wilson on 11/22/23.
//

import Foundation

struct Bathroom: Decodable {
    let name: String
    let desc: String
    let lat: Double
    let lon: Double
    let rating: Rating
}
struct Rating: Decodable {
    let t: Int
    let n: Int
}

class jsonWebVM : ObservableObject
{
    @Published var bathrooms: [String: Bathroom]?

    init()
    {
        bathrooms = [:]

    }
    func getJsonData() {

        // for the moment, ASU is a hardcoded location,
        // but in the future this could easily be expanded
        // even though this isn't graded as part of the project,
        // if you're curious, you can find the backend code at
        // https://gitlab.com/lwilson/kylpy-server
        let urlAsString = "https://kylpy.lwilson.dev/api/v1/asu"

        print(urlAsString)

        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared

        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }

            do {
                if let d = data {
                    let decodedData = try JSONDecoder().decode([String: Bathroom].self, from: d)
                    DispatchQueue.main.async {
                        self.bathrooms = decodedData
                    }
                }

            } catch {
                print("error: \(error)")
            }
        })
        jsonQuery.resume()
    }
    
    func review(id: String, val: Int) {
        print("re https://kylpy.lwilson.dev/api/v1/asu/\(id)/review/\(val)")
        let url = URL(string: "https://kylpy.lwilson.dev/api/v1/asu/\(id)/review/\(val)")!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            print("here re")
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                print(String(decoding: data!, as: UTF8.self))
            }
        }).resume()
        getJsonData()
    }
    
    func unreview(id: String, val: Int) {
        print("un https://kylpy.lwilson.dev/api/v1/asu/\(id)/unreview/\(val)")
        let url = URL(string: "https://kylpy.lwilson.dev/api/v1/asu/\(id)/unreview/\(val)")!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            print("here un")
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                print(String(decoding: data!, as: UTF8.self))
            }
        }).resume()
        getJsonData()
    }
}
