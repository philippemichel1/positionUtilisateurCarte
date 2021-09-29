//
//  SelecteurTriListe.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 25/09/2021.
//

import SwiftUI

struct SelecteurTriListe: View {
    var pictogramme:[String] = ["abc", "figure.stand"]
    @State  var selection:Int = 0
    
    @StateObject var triListe:ConnexionAPI = ConnexionAPI()
    
    
    var body: some View {
        HStack {
            Picker("", selection: $selection) {
                ForEach(0..<pictogramme.count) {choix in
                    Image(systemName: pictogramme[choix])
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selection) { ValeurChoisit in
                    if ValeurChoisit == 0 {
                        triListe.trierVilleNBHabitantsDesCroissant()
                        
                    } else {
                        triListe.trierVilleOrdreAlpha()
                    }
                }
            }
        }
    }
}

struct SelecteurTriListe_Previews: PreviewProvider {
    static var previews: some View {
        SelecteurTriListe()
    }
}
