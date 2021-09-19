//
//  ContentView.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 26/07/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var maPosition:PositionUtilisateurVueModel = PositionUtilisateurVueModel()
    @StateObject var connexionAPIVille:ConnexionAPI = ConnexionAPI()
    @StateObject var valeurAleatoire:Aleatoire = Aleatoire()
    
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
    @State var villeSelectionne: String = ""
    
    //parametre pour les vues animées
    let milieu = UIScreen.main.bounds.height / 2
    let popupHauteur:CGFloat = 200
    
    // paramétre pour animation capsule 
    @State var capsuleLargeur:CGFloat = 15
    @State var capsuleHauteur0:CGFloat = 100
    @State var capsuleHauteur1:CGFloat = 100
    @State var capsuleHauteur2:CGFloat = 100
    @State var couleurCapsule:[Color] = [Color("MonRouge"),.gray, Color("MonVert")]
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if (maPosition.positionUtilisateur == nil) {
            HStack(spacing: 0) {
                VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur0, color: $couleurCapsule[0])
                VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur1, color: $couleurCapsule[1])
                VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur2, color: $couleurCapsule[2])
                HStack {
                    Text("loadData")
                        .padding()
                }
            }.animation(.linear)
            .onReceive(timer) { time in
                capsuleHauteur0 = valeurAleatoire.hauteurAleatoire()
                capsuleHauteur1 = valeurAleatoire.hauteurAleatoire()
                capsuleHauteur2 = valeurAleatoire.hauteurAleatoire()
            }
            
        } else {
            NavigationView {
                VStack {
                    ZStack {
                        Carte(region: .constant(maPosition.donneeAffichageCarte(position: maPosition.positionUtilisateur!)))
                        //Vue animée "A propos de"
                        VuePopup()
                            .padding()
                            //.offset(x: 0, y:  montrerPopup ? -popupHauteur + popupHauteur : -milieu - popupHauteur)
                            .offset(x: 0, y:  montrerPopup ? -popupHauteur + popupHauteur : -UIScreen.main.bounds.height)
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
                                    .fill(Color("MonRouge"))
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
                                //création d'une liste de ville
                                ForEach(connexionAPIVille.listeVilles,id: \.name) {villeIndex  in
                                    HStack {
                                        Text("\(villeIndex.capital)")
                                        Text("\(villeIndex.population) Hab")
                                        Button(action: {
                                            maPosition.convertirAdresse(adresse: villeIndex.capital)
                                            villeSelectionne = villeIndex.capital
                                        }, label: {
                                            Image(systemName: Ressources.image.visualiser.rawValue)
                                                .foregroundColor(villeIndex.capital == villeSelectionne ? Color("MonVert") : Color("MonRouge"))
                                            
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
                                    .foregroundColor(textAutreLieu != "" ? Color("MonVert") : Color("MonRouge"))
                                
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
                                    villeSelectionne = ""
                                    maPosition.montrerPosition = true
                                    // redemarre la localisation GPS
                                    maPosition.majPosition()
                                    self.autreLieuSaisi = false
                                }
                                
                            }, label: {
                                Image(systemName: Ressources.image.damarrerLocalisation.rawValue)
                                    .imageScale(.large)
                                    .foregroundColor(maPosition.montrerPosition ? Color("MonVert") : Color("MonRouge"))
                            })
                            Button(action: {
                                withAnimation {
                                    villeSelectionne = ""
                                    self.autreLieuSaisi = true
                                    self.maPosition.montrerPosition = false
                                }
                                
                            }, label: {
                                Image(systemName: Ressources.image.saisirLieux.rawValue)
                                    .imageScale(.large)
                                    .foregroundColor(autreLieuSaisi ? Color("MonVert") : Color("MonRouge"))
                            })
                            Button(action: {
                                // type animation pour la fenetre popupup
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
                                {
                                    self.montrerPopup.toggle()
                                }
                                
                                
                            }, label: {
                                Text("about")
                                    .foregroundColor(montrerPopup ? Color("MonVert") : Color("MonRouge"))
                            })
                        }
                    }
                }
            }
            .onAppear {
                //Téléchagement des donnée des villes
                connexionAPIVille.startRequeteJSONDecoder()
                // trie la liste par nombre habitants lors de l'affichage e la vue
                connexionAPIVille.trierVilleNBHabitantsDesCroissant()
                changementSelection()
                print(maPosition.montrerPosition)
                
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
            connexionAPIVille.trierVilleOrdreAlpha()
            self.ordreTriAlpha.toggle()
            
        } else {
            position += 100
            pactogramme = Ressources.image.figurine.rawValue
            connexionAPIVille.trierVilleNBHabitantsDesCroissant()
            self.ordreTriAlpha.toggle()
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
