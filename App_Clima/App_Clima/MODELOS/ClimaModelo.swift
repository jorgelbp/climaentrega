//
//  ClimaModelo.swift
//  App_Clima
//
//  Created by Jorge Luis Baltazar Perez on 25/04/21.
//

import Foundation

struct ClimaModelo {
    let temperatura: Double
    let nombreCiudad: String
    let id: Int
    let sentir: Double
    let humedad: Int
    
    //propiedades calculadas
    var tempString: String{
        return String(format: "%.1f", temperatura)
    }
    var feelString: String{
        return String(format: "%.1f", sentir)
    }
   
    
    var condicionClima: String{
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.hail"
        case 500...531:
            return "cloud.sleet"
        case 600...622:
            return "snow"
        case 701...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
    
}
