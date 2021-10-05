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
    @State var montrerFiltreRecherche = true
    @State var montrerPopup:Bool = false
    @State var clavierAfficher:Bool = false
    
    //variable relative au selecteur de tri
    @State var position:CGFloat = 0
    @State var ordreTriAlpha:Bool = true
    @State var largeur:CGFloat = 100
    @State var hauteur:CGFloat = 25
    @State var pactogramme:String?
    @State var villeSelectionne: String = ""
    @State var filtreRecherche: String = ""
    
    
    
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
    
    var pictogramme:[String] = ["abc", "figure.stand"]
    @State  var selection:Int = 1
    
    //@available(iOS 15.0, *)
    var body: some View {
        if (maPosition.positionUtilisateur != nil) && (connexionAPIVille.telechargementVille) == true {
            NavigationView {
                GeometryReader { geo in
                    if #available(iOS 15.0, *) {
                        VStack {
                            ZStack {
                                Carte(region: .constant(maPosition.donneeAffichageCarte(position: maPosition.positionUtilisateur!)), clavierVisible: $clavierAfficher)
                                //Vue animée "A propos de"
                                VuePopup()
                                    .padding()
                                    .offset(x: 0, y:  montrerPopup ? -popupHauteur + popupHauteur : -UIScreen.main.bounds.height)
                            }
                            if !autreLieuSaisi {
                                //Création du selecteur de tri de la liste ville
                                HStack {
                                    Picker("", selection: $selection) {
                                        ForEach(0..<pictogramme.count) {choix in
                                            Image(systemName: pictogramme[choix])
                                            
                                            
                                        }
                                        .onChange(of: selection) { ValeurChoisit in
                                            if ValeurChoisit == 0 {
                                                connexionAPIVille.trierVilleOrdreAlpha()
                                            } else {
                                                connexionAPIVille.trierVilleNBHabitantsDesCroissant()
                                            }
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                ScrollView {
                                    LazyVStack(spacing: 20) {
                                        //création d'une liste de ville
                                        ForEach(connexionAPIVille.listeVilles,id: \.code) {villeIndex  in
                                            if filtreRecherche.isEmpty || villeIndex.nom.contains(filtreRecherche) || villeIndex.nom.lowercased().contains(filtreRecherche) {
                                                HStack {
                                                    Text("\(villeIndex.nom)")
                                                    Text("\(villeIndex.population ?? 0) Hab")
                                                    Button(action: {
                                                        if clavierAfficher {
                                                            rentrerClavier()
                                                        }
                                                        maPosition.convertirAdresse(adresse: villeIndex.nom)
                                                        villeSelectionne = villeIndex.nom
                                                    }, label: {
                                                        Image(systemName: Ressources.image.visualiser.rawValue)
                                                            .foregroundColor(villeIndex.nom == villeSelectionne ? Color("MonVert") : Color("MonRouge"))
                                                        
                                                    })
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                .frame(height: 210)
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
                                        rentrerClavier()
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
                        // clavier affiché
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                            self.clavierAfficher = true

                            
                            //clavier non afficher
                        }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                            self.clavierAfficher = false
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
                                            self.montrerFiltreRecherche = true
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
                                            self.montrerFiltreRecherche = false
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
                        // vue rechercher pour la liste de ville
                        .searchable(text: $filtreRecherche)
                    } else {
                        // Fallback on earlier versions
                    }
                } // fin du géometry
            } // fin navigationView
        } else {
            if #available(iOS 15.0, *) {
                HStack(spacing: 0) {
                    VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur0, color: $couleurCapsule[0])
                    VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur1, color: $couleurCapsule[1])
                    VueCapsule(largeur: $capsuleLargeur, hauteur: $capsuleHauteur2, color: $couleurCapsule[2])
                    HStack {
                        Text("loadData")
                            .padding()
                    }
                }
                .animation(.linear)
                .onReceive(timer) { time in
                    capsuleHauteur0 = valeurAleatoire.hauteurAleatoire()
                    capsuleHauteur1 = valeurAleatoire.hauteurAleatoire()
                    capsuleHauteur2 = valeurAleatoire.hauteurAleatoire()
                    //clavier affichier
                }
                
                // telecharche les donner à la maniere ios 15
                .task {
                    await connexionAPIVille.startRequeteJSONDecoderBis()
                }
                
            } else {
                // Fallback on earlier versions
            }// fin de onAppear
            
        } // fin de if
    } // fin de vue body
    
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
    // rentre le clavier
    func rentrerClavier() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


