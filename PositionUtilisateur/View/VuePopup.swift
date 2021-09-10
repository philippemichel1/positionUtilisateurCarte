//
//  VuePopup.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 05/09/2021.
//

import SwiftUI

struct VuePopup: View {
    @State var montrerSafari:Bool = false
    var urlString = "https://www.titastus.com"
    var body: some View {
        VStack {
            HStack {
                Image(Ressources.image.logotitastus.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Button(action: {
                    self.montrerSafari.toggle()
                }, label: {
                    Text("Titastus.com")
                        .foregroundColor(.red)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                })
                    .padding()
                    .sheet(isPresented: $montrerSafari) {
                    ControleurSafari(url: URL(string: self.urlString)!)
                    }
            }
        
        }.background(Color.gray.opacity(0.8)
                .cornerRadius(20)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.15), radius: 10, x: 1, y: 1))
    }
    
}


struct VuePopup_Previews: PreviewProvider {
    static var previews: some View {
        VuePopup()
    }
}