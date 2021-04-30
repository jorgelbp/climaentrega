//
//  ClimaManager.swift
//  App_Clima
//
//  Created by Jorge Luis Baltazar Perez on 25/04/21.
//

import Foundation
import CoreLocation

protocol ClimaManagerDelegado {
    func actualizarClima(clima: ClimaModelo)
    
    func huboError(error: Error)
}

struct ClimaManager {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=00c5bc2f5de801d68ce727c9f90df8b2&units=metric&lang=es"
    
    //quien sea delegado implementara este protocolo
    var delegado: ClimaManagerDelegado?
    
    func buscarClima(ciudad: String){
        let urlString = "\(climaURL)&q=\(ciudad)"
        realizarSolicitud(urlString: urlString)
        
    }
    
    func buscarClimaGPS(lat: CLLocationDegrees, long: CLLocationDegrees){
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(long)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String){
        //1.- Crear URL
        if let url = URL(string: urlString){
            //2.- Crear URLSession
            let session = URLSession(configuration: .default)
            //3.- Asignarle una tarea a la URLSession
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil{
                    delegado?.huboError(error: error!)
                    return
                }
                if let datosSeguros = datos{
                    if let objClima = self.parsearJSON(datosClima: datosSeguros){
                        //designar delegado
                        delegado?.actualizarClima(clima: objClima)
                       
                    }
                }
            }
            
            //4.- Iniciar la tarea
            tarea.resume()
        }
    }
    
    func parsearJSON(datosClima: Data) -> ClimaModelo?{
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados = try decodificador.decode(ClimaDatos.self, from: datosClima)
            //Imprimir los datos de la API ordenados
            print("La ciudad que buscaste es: \(datosDecodificados.name)")
            print("Temperatura: \(datosDecodificados.main.temp)")
            print("Feels: \(datosDecodificados.main.feels_like)")
            print("Descripcion: \(datosDecodificados.weather[0].description)")
            print("humedad:\(datosDecodificados.main.humidity)")
            print(datosDecodificados.weather[0].id)
            
            let id = datosDecodificados.weather[0].id
            let ciudad = datosDecodificados.name
            let temp = datosDecodificados.main.temp
            let sentido = datosDecodificados.main.feels_like
            let hume = datosDecodificados.main.humidity
            
            let objClima = ClimaModelo(temperatura: temp, nombreCiudad: ciudad, id: id, sentir: sentido, humedad: hume)
            print(objClima.condicionClima)
            print(objClima.tempString)
            
            
            return objClima
        } catch  {
            delegado?.huboError(error: error)
            return nil
        }
    }
    
}
