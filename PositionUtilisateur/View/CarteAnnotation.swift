//
//  CarteAnnotation.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 16/10/2021.
//

import SwiftUI
import MapKit

struct CarteAnnotation: View {
    @Binding var region:MKCoordinateRegion
    @Binding var  clavierVisible:Bool
    @Binding var annotation:String
    
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

//struct CarteAnnotation_Previews: PreviewProvider {
  //  static var previews: some View {
    //    CarteAnnotation()
    //}
//}
    
