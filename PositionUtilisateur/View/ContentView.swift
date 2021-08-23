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
    @State var ChoixDeTri:Int = 1
    @State var autreLieuSaisi:Bool = false
    @State var montrerAlerte = false
    
    var body: some View {
        if (maPosition.positionUtilisateur == nil) {
            HStack {
                Text("loadData")
                    .padding()
            }
            
        } else {
            NavigationView {
                VStack {
                    Carte(region: .constant(maPosition.donneeAffichageCarte(position: maPosition.positionUtilisateur!)))
                    if !autreLieuSaisi {
                        HStack {
                            //TrierListeVilles(selection: $ChoixDeTri)
                            Spacer()
                            Button(action: {
                                // trie ordre alphabetique
                                villePosition.TrierVilleOrdreAlpha()
                                
                            }, label: {
                                Image(systemName: Ressources.image.figABC.rawValue)
                            })
                            .padding(5)
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                // trie par habitant
                                villePosition.TrierVilleNBHabitantsDesCroissant()
                                
                            }, label: {
                                Image(systemName: Ressources.image.figurine.rawValue)
                            })
                            .padding(5)
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            Spacer()
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
                    }
                }
                // animation de la carte
                .animation(.linear)
                .navigationTitle(maPosition.positionUtilisateur!.ville)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button(action: {
                                maPosition.montrerPosition = true
                                // redemarre la localisation GPS
                                maPosition.majPosition()
                                self.autreLieuSaisi = false
                            }, label: {
                                Image(systemName: Ressources.image.damarrerLocalisation.rawValue).foregroundColor(maPosition.montrerPosition ? .green : .red)
                            })
                            Button(action: {
                                self.autreLieuSaisi = true
                            }, label: {
                                Image(systemName: Ressources.image.saisirLieux.rawValue)
                            })
                        }
                    }
                }
            }
            .onAppear{
                // trie la liste par nombre habitants lors de l'affichage e la vue
                villePosition.TrierVilleNBHabitantsDesCroissant()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
