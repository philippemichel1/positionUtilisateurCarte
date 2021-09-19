//
//  ConnexionAPI.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 19/09/2021.
//

import Foundation
class ConnexionAPI:ObservableObject {
    @Published var listeVilles:[ville] = []
    
    // execution de la connexion à URL
    func startRequeteJSONDecoder() {
        let urlString = "https://restcountries.eu/rest/v2/region/europe"
        
        // verication que l'on à bien une url
        if let url = URL(string: urlString) {
            //ouverture de session
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // verification à ton des donnees
                if let mesDonnees = data {
                    do {
                        // essai de decoder le fichier struct
                        let resultat = try JSONDecoder().decode([ville].self, from: mesDonnees)
                        //print(resultat)
                        DispatchQueue.main.async { [self] in
                            // lecture des variable de la struct
                            // rrempli le tableau
                            self.listeVilles = resultat
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } // fin de verivication de données
            }.resume() // resultat de la requete
            
        } // url
    }
    //Trier element du tableau par ville par ordre alphabetique
    func trierVilleOrdreAlpha()  {
        listeVilles.sort {$0.capital < $1.capital}
    }
    
    // trier les villes par nombre habitants descroissant
    func trierVilleNBHabitantsDesCroissant() {
        listeVilles.sort {$0.population > $1.population}
    }
    
}
