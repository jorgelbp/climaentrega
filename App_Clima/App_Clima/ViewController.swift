//
//  ViewController.swift
//  App_Clima
//
//  Created by Jorge Luis Baltazar Perez on 25/04/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegado, CLLocationManagerDelegate {
    
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    
    func huboError(error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            let alerta = UIAlertController(title: "Error", message: "Lugar no encontrado", preferredStyle: .actionSheet)
            
            let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alerta.addAction(accion)
            
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    
    
    var climaManager = ClimaManager()
    
    //obtener las coordenadas del ususario
    var climaLocationManager = CLLocationManager()
    
    @IBOutlet weak var feelsLabel: UILabel!
    @IBOutlet weak var ciudadTextField: UITextField!
    
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var humedadLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var condicionClimaImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        climaLocationManager.delegate = self
        
        //Pedir autorizacion
        climaLocationManager.requestWhenInUseAuthorization()
    

        //que todo el tiempo este actualizando la localización
        climaLocationManager.requestLocation()
        //establecer esta clase como protocolo del ClimaManager
        climaManager.delegado = self
        ciudadTextField.delegate = self
    }


    @IBAction func buscarButton(_ sender: UIButton) {
        print(ciudadTextField.text!)
        ciudadTextField.endEditing(true)
    }
    @IBAction func buscarGPS(_ sender: UIButton) {
        climaManager.buscarClimaGPS(lat: latitud!, long: longitud!)
        let alerta = UIAlertController(title: "latitud:\(latitud)", message: "longitud\(longitud)", preferredStyle: .actionSheet)
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alerta.addAction(accion)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    //Metodos del delegado
    
    
    //se activa cuando el usuario da click en buscar del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(ciudadTextField.text!)
        ciudadTextField.endEditing(true)
        
        //realizar la peticion a la API
        return true
    }
   
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(ciudadTextField.text != ""){
            return true
        }else{
            ciudadTextField.placeholder = "Escribe algo..."
            return false
        }
    }
    //cuando se termina de editar el TF
    func textFieldDidEndEditing(_ textField: UITextField) {
        //para poder seleccionar la palabra del teclado
        let auxi = ciudadTextField.text?.trimmingCharacters(in: .whitespaces)

        climaManager.buscarClima(ciudad: auxi!)
        //limpiar el TF
        ciudadTextField.text = ""
    }
    
    func actualizarClima(clima: ClimaModelo) {
        DispatchQueue.main.async {
            self.temperaturaLabel.text = clima.tempString
            self.ciudadLabel.text = clima.nombreCiudad
            self.condicionClimaImage.image = UIImage(systemName: clima.condicionClima)
            self.feelsLabel.text = clima.feelString
            self.humedadLabel.text = String(clima.humedad)
        }
    }
    
    //Metodos de ubicacion
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubicacion = locations.last{
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            self.latitud = latitud
            self.longitud = longitud
            print("Se obtubo la ubicación \(latitud), \(longitud)")
            climaManager.buscarClimaGPS(lat: latitud, long: longitud)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación")
    }
}

