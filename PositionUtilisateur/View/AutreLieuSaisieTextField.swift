//
//  AutreLieuSaisieTextField.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 23/08/2021.
//

import SwiftUI

struct AutreLieuSaisieTextField: View {
    @Binding var autreLieu:String
    var body: some View {
        TextField("textField", text: $autreLieu)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .border(Color.red)
            .frame(width: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct AutreLieuSaisieTextField_Previews: PreviewProvider {
    static var previews: some View {
        AutreLieuSaisieTextField(autreLieu: .constant("Dijon"))
            .previewLayout(.sizeThatFits)
        
    }
}
