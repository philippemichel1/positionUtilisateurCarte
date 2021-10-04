//
//  Carte.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 31/07/2021.
//

import SwiftUI
import MapKit

struct Carte: View {
    @Binding var region:MKCoordinateRegion
    @Binding var  clavierVisible:Bool
    var hauteurLargeur:CGFloat = 270
    
    var body: some View {
        HStack {
            Spacer()
            Map(coordinateRegion: $region)
                .frame(width: dimensionCarte(), height: dimensionCarte())
                
        }
    }
    //dimension carte
    func dimensionCarte()  -> CGFloat {
      return  clavierVisible ? hauteurLargeur / 2 : hauteurLargeur
    }
}
