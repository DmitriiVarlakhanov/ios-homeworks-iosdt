//
//  NetworkService.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 12/8/25.
//

import Foundation

struct NetworkService {

    // MARK: - Type methods

    static func request(for configuration: AppConfiguration) {
        switch configuration {
        case .first(let firstConfiguration):
            let url = URL(string: firstConfiguration)

            let urlSesion = URLSession.shared

            let task = urlSesion.dataTask(with: url!) { data, response, error in
                if let error = error {
                    print("Пункт 7.c:")
                    print(error.localizedDescription)
                }

                // Error code: -1009

                if let nsError = error as? NSError {
                    print("Error code: \(nsError.code)")
                    print()
                }

                if let HTTPURLResponse = response as? HTTPURLResponse {
                    print("Пункт 7.b:")
                    print("All header fields: \(HTTPURLResponse.allHeaderFields)")
                    print()
                    print("Status code: \(HTTPURLResponse.statusCode)")
                    print()
                }

                guard let data = data else {
                    print("Error: No data returned")
                    return
                }

                print("Пункт 7.a:")

                do {
                    let foundationObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                    for (key, value) in foundationObject! {
                        print("\(key) - \(value)")
                    }
                } catch {
                    print("Error parsing JSON")
                }
            }

            task.resume()
        case .second(let secondConfiguration):
            let url = URL(string: secondConfiguration)

            let urlSesion = URLSession.shared

            let task = urlSesion.dataTask(with: url!) { data, response, error in
                if let error = error {
                    print("Пункт 7.c:")
                    print(error.localizedDescription)
                }

                // Error code: -1009

                if let nsError = error as? NSError {
                    print("Error code: \(nsError.code)")
                    print()
                }

                if let HTTPURLResponse = response as? HTTPURLResponse {
                    print("Пункт 7.b:")
                    print("All header fields: \(HTTPURLResponse.allHeaderFields)")
                    print()
                    print("Status code: \(HTTPURLResponse.statusCode)")
                    print()
                }

                guard let data = data else {
                    print("Пункт 7.a:")
                    print("Error: No data returned")
                    return
                }

                print("Пункт 7.a:")

                do {
                    let foundationObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                    for (key, value) in foundationObject! {
                        print("\(key) - \(value)")
                    }
                } catch {
                    print("Error parsing JSON")
                }
            }

            task.resume()
        case .third(let thirdConfiguration):
            let url = URL(string: thirdConfiguration)

            let urlSesion = URLSession.shared

            let task = urlSesion.dataTask(with: url!) { data, response, error in
                if let error = error {
                    print("Пункт 7.c:")
                    print(error.localizedDescription)
                }

                // Error code: -1009

                if let nsError = error as? NSError {
                    print("Error code: \(nsError.code)")
                    print()
                }

                if let HTTPURLResponse = response as? HTTPURLResponse {
                    print("Пункт 7.b:")
                    print("All header fields: \(HTTPURLResponse.allHeaderFields)")
                    print()
                    print("Status code: \(HTTPURLResponse.statusCode)")
                    print()
                }

                guard let data = data else {
                    print("Error: No data returned")
                    return
                }

                print("Пункт 7.a:")

                do {
                    let foundationObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                    for (key, value) in foundationObject! {
                        print("\(key) - \(value)")
                    }
                } catch {
                    print("Error parsing JSON")
                }
            }

            task.resume()
        }
    }
}
