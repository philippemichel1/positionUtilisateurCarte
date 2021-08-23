//
//  TrierListeVilles.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 21/08/2021.
//

import SwiftUI

struct TrierListeVilles: View {
    @Binding var selection:Int
    var pictogramme:[String] = ["abc", "figure.stand"]
    var selectiontrie:VilleVueModel = VilleVueModel()
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(0..<pictogramme.count) {choix in
                    Image(systemName: pictogramme[choix])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
}


struct TrierListeVilles_Previews: PreviewProvider {
    static var previews: some View {
        TrierListeVilles(selection: .constant(0))
    }
}
