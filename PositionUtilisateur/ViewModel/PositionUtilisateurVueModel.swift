//
//  PositionUtilisateurVueModel.swift
//  PositionUtilisateur
//
//  Created by Philippe MICHEL on 26/07/2021.
//

import Foundation
import CoreLocation
import MapKit


class PositionUtilisateurVueModel:NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var positionUtilisateur: PositionUtilisateur?
    @Published var montrerPosition:Bool = true
    private var manager = CLLocationManager()
    var statutLocalisation:CLAuthorizationStatus?
    // initialisation de la viriable Géocoder
    private var geo = CLGeocoder()
    
    
    
    override init() {
        super.init()
        manager.delegate = self
        // autorisation de localisation
        manager.requestWhenInUseAuthorization()
        // presition de ma localisation
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //Maj des donnees tout les 1 km
        manager.distanceFilter = 1000
        majPosition()
        
    }
    
    // autorisation de localisation
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let maPosition = locations.last else { return }
        //Convertisse en mon modele
        convertirCoordone(position: maPosition)
    }
    
    // mise à jour de la position
    func majPosition() {
        montrerPosition ? manager.startUpdatingLocation() : manager.stopUpdatingLocation()
        //togglePosition()
    }
    
    func togglePosition() {
        montrerPosition.toggle()
    }
    
    // mise en place du géocoder pour convertir une adresse en position géographique et inversement.//
    
    //convertir un point géographique en localisation
    func convertirCoordone(position: CLLocation) {
        geo.reverseGeocodeLocation(position, completionHandler: geoCodeCompletion(resultat:erreur:))
    }
    // convertir un lieu en point géographique
    func convertirAdresse(adresse: String) {
        montrerPosition = false
        manager.stopUpdatingLocation()
        geo.geocodeAddressString(adresse, completionHandler: geoCodeCompletion(resultat:erreur:))
    }
    
    func geoCodeCompletion(resultat: [CLPlacemark]?, erreur: Error?) {
        guard let listeResultats = resultat?.first else {return}
        let coordonee = listeResultats.location?.coordinate
        let latitude = coordonee?.latitude ?? 0
        let longitude = coordonee?.longitude ?? 0
        let ville = listeResultats.locality ?? ""
        let pays = listeResultats.country ?? ""
        let nouvellePositionUtilisateur = PositionUtilisateur(latitude: latitude, longitude: longitude, ville: ville, pays: pays)
        self.positionUtilisateur = nouvellePositionUtilisateur
    }
    
    //donnée pour affichage de la carte
    func donneeAffichageCarte(position:PositionUtilisateur) -> MKCoordinateRegion {
        let centre = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
        // présition de detail de la carte
        let portee = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
       
        return MKCoordinateRegion(center: centre, span: portee)
    }
}
