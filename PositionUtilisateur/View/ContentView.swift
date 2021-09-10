//
//  ContentView.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 26/07/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var maPosition:PositionUtilisateurVueModel = PositionUtilisateurVueModel()
    @StateObject var villePosition:VilleVueModel = VilleVueModel()
    @State var textAutreLieu:String = ""
    //@State var ordreTriAlphab:Bool = true
    @State var autreLieuSaisi:Bool = false
    @State var montrerAlerte = false
    @State var montrerPopup:Bool = false
    
    //variable relative au selecteur de tri
    @State var position:CGFloat = 0
    @State var ordreTriAlpha:Bool = true
    @State var largeur:CGFloat = 100
    @State var hauteur:CGFloat = 25
    @State var pactogramme:String?
    
    //parametre pour la vue animée
    let milieu = UIScreen.main.bounds.height / 2
    let popupHauteur:CGFloat = 200
    
    

    
    
    var body: some View {
        if (maPosition.positionUtilisateur == nil) {
            HStack {
                Text("loadData")
                    .padding()
            }
            
        } else {
            NavigationView {
                VStack {
                    ZStack {
                    Carte(region: .constant(maPosition.donneeAffichageCarte(position: maPosition.positionUtilisateur!)))
                       //Vue animée "A propos de"
                        VuePopup()
                            .padding()
                            .offset(x: 0, y:  montrerPopup ? -popupHauteur + popupHauteur : -milieu - popupHauteur)
                       
 
                        
                    }
                    if !autreLieuSaisi {
                        HStack {
                            //Création du selecteur de tri de la liste ville
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
                                
                                Image(systemName: pactogramme!)
                                    .foregroundColor(.white)
                                    .offset(CGSize(width: position + (largeur / 2), height: 0))
                            }
                            
                            // fin de code selecteur de tri
                        }
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                //creation d'une liste de ville avec une boucle ForEach
                                ForEach(villePosition.ville,id: \.id) {indexCmmune  in
                                    HStack {
                                        Text("\(indexCmmune.nom)")
                                        Text("\(indexCmmune.NBHabitants) Hab")
                                        Button(action: {
                                            maPosition.convertirAdresse(adresse: indexCmmune.nom)
                                        }, label: {
                                            Image(systemName: Ressources.image.visualiser.rawValue)
                                        })
                                    }
                                }
                            }
                        }

                    } else {
                        // autre lieu choisit
                        VStack {
                            TitreFormAutreLieuText()
                        }
                        HStack {
                            //appel du dormulaire de saisie autre ville
                            AutreLieuSaisieTextField(autreLieu: $textAutreLieu)
                            Button(action: {
                                // rentre le clavier
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                verificationSaisie()
                    
                            }, label: {
                                Image(systemName: Ressources.image.validerLieu.rawValue)
                            })
                            .alert(isPresented: $montrerAlerte, content: {
                                Alert(title: Text("alert"))
                            })
                        }
                        Spacer()
                    }
                }
                // animation de la carte
                .animation(.linear)
                .navigationTitle(maPosition.positionUtilisateur!.ville)
                //Gestion de la barre d'état et des boutons de fonction
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack(spacing: 50) {
                            Button(action: {
                                withAnimation {
                                    maPosition.montrerPosition = true
                                    // redemarre la localisation GPS
                                    maPosition.majPosition()
                                    self.autreLieuSaisi = false
                                }
                                
                            }, label: {
                                Image(systemName: Ressources.image.damarrerLocalisation.rawValue).foregroundColor(maPosition.montrerPosition ? .green : .red)
                                    .imageScale(.large)
                            })
                            Button(action: {
                                withAnimation {
                                    self.autreLieuSaisi = true
                                }
                                
                            }, label: {
                                Image(systemName: Ressources.image.saisirLieux.rawValue)
                                .imageScale(.large)
                            })
                            Button(action: {
                                withAnimation(.linear(duration: 0.5)) {
                                    self.montrerPopup.toggle()
                                }
                               
                                
                            }, label: {
                                Text("about")
                            })
                        }
                    }
                }
            }
            .onAppear{
                // trie la liste par nombre habitants lors de l'affichage e la vue
                villePosition.TrierVilleNBHabitantsDesCroissant()
                changementSelection()
            }
        }
        
    }
    //verification que le champs n'est pas vide
    func verificationSaisie() {
        if textAutreLieu == "" {
            // Message alerte
            montrerAlerte = true
        } else {
            montrerAlerte = false
            maPosition.convertirAdresse(adresse: textAutreLieu)
            self.textAutreLieu = ""
        }
    }
    
    //fonction de changement de selection
    func changementSelection() {
        if !ordreTriAlpha {
            position -= 100
            pactogramme = Ressources.image.figABC.rawValue
            villePosition.TrierVilleOrdreAlpha()
            self.ordreTriAlpha.toggle()
            
        } else {
            position += 100
            pactogramme = Ressources.image.figurine.rawValue
            villePosition.TrierVilleNBHabitantsDesCroissant()
            self.ordreTriAlpha.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
