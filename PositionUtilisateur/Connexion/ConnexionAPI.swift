//
//  ConnexionAPI.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 19/09/2021.
//

import Foundation
import SwiftUI
class ConnexionAPI:ObservableObject {
    @Published var listeVilles:[communes] = []
     @Published var telechargementVille = false

    //Nouvelle methode IOS 15 pour le téléchargement de donnée et les taches asynchrone
    @available(iOS 15.0.0, *)
    func startRequeteJSONDecoderBis() async {
        // verification chaine de type url
        guard let urlString = URL(string: "https://geo.api.gouv.fr/communes") else {return}
        
        do {
            // connexion url session
            let (mesDonnees, _) = try await URLSession.shared.data(from: urlString)
            listeVilles = try JSONDecoder().decode([communes].self, from: mesDonnees)
            trierVilleNBHabitantsDesCroissant()
            self.telechargementVille = true
            
        } catch {
            print(error.localizedDescription)
            self.telechargementVille = false
        }
    }
   
    
    //Trier element du tableau par ville par ordre alphabetique
    func trierVilleOrdreAlpha()  {
       listeVilles.sort {$0.nom < $1.nom}
    }
    
    // trier les villes par nombre habitants descroissant
    func trierVilleNBHabitantsDesCroissant() {
        listeVilles.sort {$0.population ?? 0 > $1.population ?? 0}
    }
    
}
