//
//  DonneeDecodable.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 19/09/2021.
//

import Foundation
struct communes:Decodable {
    var nom:String
    var code:String
    //var codeRegion:String
    var population:Int64?
}

