//
//  ViewController.swift
//  Aprendiendo-Servicios
//
//  Created by José Javier Cueto Mejía on 07/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit

struct Human: Codable{
    let user: String
    let age:Int
    let isHappy: Bool
}


class ViewController: UIViewController {
    
    //MARK: - References UI
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchService()
    }
    
    // http://www.mocky.io/v2/5e2674472f00002800a4f417
    // excepcion de seguridad - ok
    // crear url con el endpoint -ok
    // hacer request con la ayuda de URLSession= pk
    // trasformar respuesta a diccionario = ok
    // ejecutar Request =ok
    
    private func fetchService(){
        let endpointString = "http://www.mocky.io/v2/5e2674472f00002800a4f417"
        guard let endpoint = URL(string: endpointString) else {
            return
        }
        
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: endpoint) { (data: Data?, _, error: Error?) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if error != nil {
                print("hubo un error")
                return
            }
            
            
            guard let dataFromService = data,
                let model:Human = try? JSONDecoder().decode(Human.self, from: dataFromService) else {
                return
            }
            
            // all called in UI is in the main thread
            DispatchQueue.main.async {
                let isHappy = model.isHappy
                self.nameLabel.text = model.user
                self.statusLabel.text = isHappy ? "Es feliz 😁": "Esta triste 🙁"
            }
           
        
            
        }.resume()
    }


}

