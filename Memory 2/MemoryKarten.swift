//
//  MemoryKarten.swift
//  Memory 2
//
//  Created by Iman Kefayati on 17.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import Cocoa

class MemoryKarten: NSButton {

    // MARK: - Eigenschaften
    
    // Eine eindeutige ID zur Indentifizierung des Bildes
    var bildID: Int!
    
    // Bilder für die Vorder- und Rückseite
    var bildVorne, bildHinten: NSImage!
    
    // Wo liegt die Karte im Spielfeld?
    var bildPos: Int!
    
    // Ist die Karte umgedreht?
    var umgedreht: Bool!
    
    // Ist die Karte noch im Spiel?
    var nochImSpiel: Bool!
    
    // Für das Spielfeld
    var spiel: ViewController!
    
    
    // MARK: - Der Initialisierer
    
    // Er setzt die Größe, die Bilder und die Postition
    init(vorne: String, bildID: Int, position: CGRect, spiel: ViewController) {
        
        // Der Initialisierer der Basis Klasse aufrufen
        // dabei wird die Position weitergereicht
        super.init(frame: position)
        
        // Die Vorderseite, der Name des Bildes wird an den
        // Initialisierer übergeben
        bildVorne = NSImage(named: vorne)
        // Die Größe des Bildes setzen
        bildVorne.size = NSSize(width: 128, height: 128)
        
        // Die Rückseite wird fest gesetzt
        bildHinten = NSImage(named: "verdeckt")
        // Die Größe des Bildes setzen
        bildHinten.size = NSSize(width: 128, height: 128)
        
        
        // Die Eigenschaften zuweisen
        // Das Bild
        self.image = bildHinten
        
        // Die Bild-ID
        self.bildID = bildID
        
        // Die Karte ist erst einmal umgedreht und noch im Feld
        umgedreht = false
        nochImSpiel = true
        
        // Mit dem Spielfeld verbinden
        self.spiel = spiel
        
        
        // Die Action ergänzen
        // Erst das Ziel
        self.target = self
        
        // Dann die Methode
        self.action = #selector(buttonClicked)
    }
    
    // Der Initialisierer wird durch die Basisklasse erzwungen
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Der andere Initialisierer ruft den etnsprechenden
    // Initialisierer der Basisklasse auf
    override init(frame: NSRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Methoden
    
    // Die Methode für das Anklicken
    @objc func buttonClicked() {
        
        // Ist die Karte überhaupt noch im Spiel
        if nochImSpiel == false { // Hier muss ein oder Anweisung ergänzt werden
            return
        }
        
        // Wenn die Rückseite zu sehen ist, die Vorderseite anzeigen
        if umgedreht == false {
            vorderseiteZeigen()
            
            // Die Methode karteOeffnen() im ViewController aufrufen
            // Übergeben wird dabei die Karte - also self
            
        }
    }
    
    // Die Methode zeigt die Rückseite der Karte an
    func rueckseiteZeigen(rausnehmen: Bool) {
        
        // Soll die Karte komplett aus dem Spiel genommen werden?
        if rausnehmen == true {
            
            // Das Bild aufgedeckt zeigen und die Karte aus dem Spiel
            // nehmen
            self.image = NSImage(named: "aufgedeckt")
            self.image?.size = NSSize(width: 128, height: 128)
            nochImSpiel = false
        } else {
            
            // Sonst nur die Rückseite zeigen
            self.image = bildHinten
            umgedreht = false
        }
    }
    
    // die Methode zeigt die Vorderseite der Karte an
    func vorderseiteZeigen() {
        self.image = bildVorne
        umgedreht = true
    }
    
    // Die Methode liefert die Bild-ID einer Karte
    func getBildID() -> Int {
        return bildID
    }
    
    // Die Methode liefert die Position einer Karte
    func getBildPos() -> Int {
        return bildPos
    }
    
    // Die Methode setzt die Position einer Karte
    func setBildPos(bildPos: Int) {
        self.bildPos = bildPos
    }
    
    // Die Methode liefert den Wert der Eigenschaft umgedreht
    func getUmgedreht() -> Bool {
        return umgedreht
    }
    
    // Die Methode liefetr den Wert der Eigenschaft nochImSpiel
    func getNochImSpiel() -> Bool {
        return nochImSpiel
    }
}
