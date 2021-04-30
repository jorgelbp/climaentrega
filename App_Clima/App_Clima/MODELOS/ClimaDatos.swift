//
//  ClimaDatos.swift
//  App_Clima
//
//  Created by Jorge Luis Baltazar Perez on 25/04/21.
//

import Foundation

struct ClimaDatos: Decodable {
    let name: String
    let id: Int
    let cod: Int
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}
struct Weather: Decodable {
    let description: String
    let id: Int
}
