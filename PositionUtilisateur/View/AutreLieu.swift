//
//  AutreLieu.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 08/08/2021.
//

import SwiftUI

struct AutreLieu: View {
    @State var texteLieu:String = ""
    @State var montrerAlerte = false
    @StateObject var carteMAJ:PositionUtilisateurVueModel = PositionUtilisateurVueModel()
    @Environment(\.presentationMode) var fermetureVue
    var body: some View {
        HStack {
            Form {
                TextField("textField", text: $texteLieu)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Button(action: {
                    
                    verifSaisie()
                    // mise à jour de la carte
                    carteMAJ.convertirAdresse(adresse: texteLieu)
                    
                }, label: {
                    Image(systemName: Ressources.image.validerLieu.rawValue)
                })
                .alert(isPresented: $montrerAlerte, content: {
                    Alert(title: Text("alert"))
                })
                
            }
        }
    }
    //verification que le champs n'est pas vide
    func verifSaisie() {
        if texteLieu == "" {
            // Message alerte
            montrerAlerte = true
        } else {
            montrerAlerte = false
            self.fermetureVue.wrappedValue.dismiss()
        }
    }

}


struct AutreLieu_Previews: PreviewProvider {
    static var previews: some View {
        AutreLieu()
    }
}
