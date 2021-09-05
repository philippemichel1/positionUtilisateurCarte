//
//  SelecteurTriListe.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 04/09/2021.
//

import SwiftUI

struct SelecteurTriListe: View {
    @State var position:CGFloat = 0
    @Binding var ordreTriAlpha:Bool
    @State var largeur:CGFloat = 100
    @State var hauteur:CGFloat = 25
    @State var texte:String = "1"
    @State var  VilleTrierPar:VilleVueModel = VilleVueModel()
    
    var body: some View {
        ZStack(alignment:.leading ) {
            HStack(spacing:0) {
                //premier rectangle de base du selecteur
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: largeur, height: hauteur, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        changementSelection()
                    }
                //deuxieme rectangle de base du selecteur
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: largeur, height: hauteur, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        changementSelection()
                    }

            }
            //rectangle de selection qui se déplace
            Rectangle()
                .fill(Color.red)
                .frame(width: largeur, height: hauteur, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(CGSize(width: position, height: 0))
            Spacer()
                Text(texte)
                    .offset(CGSize(width: position, height: 0))
        }
    }
    //fonction de changement de selection
    func changementSelection() {
        if !ordreTriAlpha {
            position -= 100
            print("Tata")
            texte = "1"
            VilleTrierPar.TrierVilleOrdreAlpha()
            self.ordreTriAlpha.toggle()
            
        } else {
            position += 100
            print("toto")
            texte = "2"
            VilleTrierPar.TrierVilleNBHabitantsDesCroissant()
            self.ordreTriAlpha.toggle()
        }
    }
}

struct SelecteurTriListe_Previews: PreviewProvider {
    static var previews: some View {
        SelecteurTriListe( ordreTriAlpha: .constant(true))
    }
}
