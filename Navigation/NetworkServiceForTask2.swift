//
//  NetworkServiceForTask2.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/12/25.
//

import Foundation

struct NetworkServiceForTask2 {

    // MARK: - Type methods

    static func request(completionHandler: @escaping (String) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/")!

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error requesting data - \(error.localizedDescription)")

                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Response error: status code - \(response.statusCode)")

                return
            }

            guard let data = data else {
                print("No data retrieved")

                return
            }

            do {
                let answer = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]

                let i = 0

                let answerDictionary = answer![i]

                let userIDJSONStruct = UserIDJSONStruct(
                    userId: answerDictionary["userId"] as! Int,
                    id: answerDictionary["id"] as! Int,
                    title: answerDictionary["title"] as! String,
                    completed: answerDictionary["completed"] as! Bool
                )

                completionHandler(userIDJSONStruct.title)
            } catch {
                print("Error parsing data")
            }
        }

        task.resume()
    }

    static func requestUsingDecodable(completionHandler: @escaping (String, [String]) -> Void) {
        let url = URL(string: "https://swapi.dev/api/planets/1")!

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error requesting data - \(error.localizedDescription)")

                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Response error: status code - \(response.statusCode)")

                return
            }

            guard let data = data else {
                print("No data retrieved")

                return
            }

            do {
                let answer = try JSONDecoder().decode(PlanetJSONStruct.self, from: data)

                completionHandler(answer.orbitalPeriod, answer.residents)
            } catch {
                print("Error parsing data")
            }
        }

        task.resume()
    }

    static func requestUsingDecodableForResidents(residentsURL: String, completionHandler: @escaping (ResidentModel) -> Void) {
        let url = URL(string: residentsURL)!

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error requesting data - \(error.localizedDescription)")

                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Response error: status code - \(response.statusCode)")

                return
            }

            guard let data = data else {
                print("No data retrieved")

                return
            }

            do {
                let answer = try JSONDecoder().decode(ResidentModel.self, from: data)

                completionHandler(answer)
            } catch {
                print("Error parsing data")
            }
        }
        task.resume()
    }
}
