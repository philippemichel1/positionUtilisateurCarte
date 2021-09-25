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
    var body: some View {
        HStack {
            Spacer()
            Map(coordinateRegion: $region)
                .frame(width: 270, height: 270)
                
        }
    }
}

