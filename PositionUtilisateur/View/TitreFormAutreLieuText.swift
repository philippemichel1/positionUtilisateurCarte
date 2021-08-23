//
//  TitreFormAutreLieuText.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 23/08/2021.
//

import SwiftUI

struct TitreFormAutreLieuText: View {
    
    var body: some View {
        
        Text("anotherPlace")
            .padding(10)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
    }
}

struct TitreFormAutreLieuText_Previews: PreviewProvider {
    static var previews: some View {
        TitreFormAutreLieuText()
            .previewLayout(.sizeThatFits)
    }
}
