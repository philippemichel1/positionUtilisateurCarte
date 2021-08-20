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
    //@State var montrerVueAutreLieu:Bool = false
    @State var textAutreLieu:String = ""
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
                        HStack {
                            TextField("textField", text: $textAutreLieu)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
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
                               // self.montrerVueAutreLieu.toggle()
                                self.autreLieuSaisi = true
                            }, label: {
                                Image(systemName: Ressources.image.saisirLieux.rawValue)
                            })
                        }
                    }
                }
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
