//
//  Aleatoire.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 14/09/2021.
//

import Foundation
import SwiftUI

class Aleatoire : ObservableObject {
    @Published var Hauteur:CGFloat = 200
    
    func hauteurAleatoire() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(Hauteur)))
    }
}
