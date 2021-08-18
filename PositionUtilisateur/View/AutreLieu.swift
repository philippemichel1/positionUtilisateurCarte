//
//  AutreLieu.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 08/08/2021.
//

import SwiftUI

struct AutreLieu: View {
    @Binding var texteLieu:String
    @Binding var lieuEstSaisi:Bool
    @State var montrerAlerte = false
    @Environment(\.presentationMode) var fermetureVue
    var body: some View {
        HStack {
            Form {
                TextField("textField", text: $texteLieu)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Button(action: {
                    verifSaisie()
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
            lieuEstSaisi = false
        } else {
            self.fermetureVue.wrappedValue.dismiss()
            montrerAlerte = false
            lieuEstSaisi = true
            
        }
    }

}


struct AutreLieu_Previews: PreviewProvider {
    static var previews: some View {
        AutreLieu(texteLieu: .constant("mon lieu"), lieuEstSaisi: .constant(false))
    }
}
