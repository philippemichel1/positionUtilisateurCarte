//
//  DonneeDecodable.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 19/09/2021.
//

import Foundation
struct ville:Decodable {
    var name:String
    var capital:String
    var population: Int64
}

