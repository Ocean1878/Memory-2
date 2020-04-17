//
//  ViewController.swift
//  Memory 2
//
//  Created by Iman Kefayati on 17.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var labelPaareMensch: NSTextField!
    
    @IBOutlet weak var labelPaareComputer: NSTextField!
    
    @IBOutlet weak var labelSpielStaerke: NSTextField!
    
    @IBOutlet weak var staerkeSlider: NSSlider!
    
    @IBOutlet weak var schummelButton: NSButton!
    
    
    // MARK: - Eigenschaften
    
    // Das Array für die Karten
    var karten = [MemoryKarten]()
    
    // Das Array für die Namen der Grafiken
    var bilder = ["alien", "beagel", "blau", "chili", "cocacola", "cool", "dackel", "grinse", "hut", "instagram", "kack", "kurbis", "kuss", "pac-man", "piratkurbis", "steckdose", "stern", "teufel", "tokyo", "vampir", "verliebt"]
    
    // Das Array für das aktuell umgedrehte Paar
    var paar = [MemoryKarten]()
    
    // Das Array für das Gedächtnis des Computers
    // Er speichert hier paarweise, wo das Gegenstück liegt
    // in ein zwei Dimensionalen Array
    var gemerkteKarten = [[Int]]()
    
    // Für die Punkte
    var menschPunkte, computerPunkte: Int!
    
    // Wie viele Karten sind aktuell umgedreht?
    var umgedrehteKarten: Int!
    
    // Für den aktuellen Spieler
    var spieler: Int!
    
    // Für die Spielstärke
    var spielstaerke = 5
    
    // Der Timer
    var timer = Timer()
    
    
    // MARK: - Methoden
    
    // Die Methode zum Initialisieren des Spielfeldes
    func initMeinSpielfeld() {
        
        // Zum zählen für die Bilder
        var count = 0
        
        // Keiner hat zu Beginn einen Punkt
        menschPunkte = 0
        computerPunkte = 0
        
        // Es ist keine Karte umgedreht
        umgedrehteKarten = 0
        
        // Der Mensch fängt an
        spieler = 0
        
        // Das Array für die gemerkten Karten aufbauen
        // Alle Werte sind -1
        // Es gibt also erst einmal keine gemerkten Karten
        for _ in 0 ..< 2 {
            gemerkteKarten.append(Array(repeating: -1, count: 21))
        }
        
        // Zwei leere Karten in das Array für die Paare einfügen
        for _ in 0 ..< 2 {
            paar.append(MemoryKarten())
        }
        
        // Ein Array mit den Positionen erzeugen und mischen
        var positionen = [Int]()
        
        for i in 0 ..< 42 {
            positionen.append(i)
            positionen = positionen.shuffled()
        }
        
        // Das eigentliche Spielfeld erstellen
        for i in 0 ..< 42 {
            
            // Eine neue Karte erzeugen
            karten.append(MemoryKarten(vorne: bilder[count], bildID: count, position: CGRect(x: (positionen[i] % 6) * 128, y: ((positionen[i] / 6) + 1) * 128, width: 128, height: 128), spiel: self))
            
            // Die Postition der Karte setzen
            karten[i].setBildPos(bildPos: i)
            
            // Die Karte hinzufügen
            self.view.addSubview(karten[i])
            
            // bei jeder zweiten Karte kommt auch ein neues Bild
            if (i + 1) % 2 == 0 {
                count = count + 1
            }
        }
    }
    
    // Die Methode Meldungen
    func meinDialog(header: String, text: String) {
        
        // Den Dialog erzeugen
        let meinDialog: NSAlert = NSAlert()
        
        // Die Texte zuweisen
        meinDialog.messageText = header
        meinDialog.informativeText = text
        
        // Und anzeigen
        meinDialog.runModal()
    }
    
    // Die Methode übernimmt die wesentliche Steuerung des Spiels
    // Sie wird beim Anklicken einer Karte ausgeführt
    func karteOeffnen(karte: MemoryKarten) {
        
        // Zum Zwischenspeichern der ID und der Position
        var kartenID, kartenPos: Int
        // Die Karte zwischenspeichern
        paar[umgedrehteKarten] = karte
        
        // Die ID wird die Position beschaffen
        kartenID = karte.getBildID()
        kartenPos = karte.getBildPos()
        
        // Die Karte in das Gedächtnis des Computers eintragen, aber
        // nur dann, wenn es noch keinen Eintrag an der entsprechenden
        // Stelle gibt
        if gemerkteKarten[0] [kartenID] == -1 {
            gemerkteKarten[0] [kartenID] = kartenPos
        } else {
            
            // Wenn es schon einen Eintrag gibt und der nicht mit der
            // aktuellen Position übereinstimmt, dann haben wir die
            // zweite Karte gefunden
            // Sie wird in die zweite Dimension eingetragen
            if gemerkteKarten[0] [kartenID] != kartenPos {
                gemerkteKarten[1] [kartenID] = kartenPos
            }
        }
        
        // Umgedrehte Karten erhöhen
        umgedrehteKarten = umgedrehteKarten + 1
        
        // Sind 2 Karten umgedreht worden?
        if umgedrehteKarten == 2 {
            
            // Dann prüfen wir, ob es ein Paar ist
            paarPruefen(kartenID: kartenID)
            
            // Die Karten wieder umdrehen mit Verzögerung von 2 Sekunden
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(karteSchliessen), userInfo: nil, repeats: false)
        }
        
        if (menschPunkte > computerPunkte) && (computerPunkte + menschPunkte == 21) {
            
            // Dialog
            meinDialog(header: "Sie haben Gewonnen!", text: "Ihr Punktestand: \(labelPaareMensch.integerValue) \n\nPunktestand Gegner: \(labelPaareComputer.integerValue) \n\nDas Spiel ist vorbei!")
            
            // Das Spiel beenden
            NSApplication.shared.terminate(self)
        } else if (menschPunkte < computerPunkte) && (computerPunkte + menschPunkte == 21) {
            
            // Dialog
            meinDialog(header: "Sie haben verloren!", text: "Punktestand Gegner: \(labelPaareComputer.integerValue) \n\nIhr Punktestand: \(labelPaareMensch.integerValue) \n\nDas Spiel ist vorbei!")
            
            // Das Spiel beenden
            NSApplication.shared.terminate(self)
        }
    }
    
    // Die Methode prüft, ob ein Paar gefunden wurde
    func paarPruefen(kartenID: Int) {
        
        if paar[0].getBildID() == paar[1].getBildID() {
            
            // Die Punkte setzen
            paarGefunden()
            
            // Die Karte aus dem Gedächtnis löschen
            gemerkteKarten[0] [kartenID] = -2
            gemerkteKarten[1] [kartenID] = -2
        }
    }
    
    // Die Methode setzt die Punkte, wenn ein Paar gefunden wurde
    func paarGefunden() {
        
        // Spielt gerade der Mensch?
        if spieler == 0 {
            
            // Die Punkte für den Menschen setzen
            menschPunkte = menschPunkte + 1
            labelPaareMensch.integerValue = menschPunkte
        } else {
            computerPunkte = computerPunkte + 1
            labelPaareComputer.integerValue = computerPunkte
        }
    }
    
    // Die Methode dreht die Karten wieder auf die Rückseite
    // bzw. nimmt sie aus dem Spiel
    @objc func karteSchliessen() {
        
        var raus = false
        
        // Ist es ein Paar?
        if paar[0].getBildID() == paar[1].getBildID() {
            raus = true
        }
        
        // Wenn es ein Paar war, nehmen wir die Karten raus
        paar[0].rueckseiteZeigen(rausnehmen: raus)
        paar[1].rueckseiteZeigen(rausnehmen: raus)
        
        // Es ist keine Karte mehr geöffnet
        umgedrehteKarten = 0
        
        // Hat der Spieler kein Paar gefunden
        if raus == false {
            
            // Dann wird der Spieler gewechselt
            spielerWechsel()
        } else {
            
            // Hat der Computer ein Paar gefunden?
            // Dann ist er noch einmal an der Reihe
            if spieler == 1 {
                computerZug()
            }
        }
    }
    
    // Die Methode wechselt den Spieler
    func spielerWechsel() {
        
        // Wenn der Mensch an der Reihe war, kommt jetzt der Computer zum Zug
        // Die Schummeltaste wird jedes mal aktiviert, wenn der Anwender
        // am Zug ist und nicht der Computer
        if spieler == 0 {
            schummelButton.isEnabled = false
            spieler = 1
            computerZug()
        } else {
            spieler = 0
            schummelButton.isEnabled = true
        }
    }
    
    // Die Methode setzt die Computerzüge um
    func computerZug() {
        
        var kartenZaehler = 0
        var zufall = 0
        var treffer = false
        
        // Zur Steuerung der Spielstärke
        if Int(arc4random_uniform(UInt32(spielstaerke))) == 0 {
            
            // Erst einmal nach einem Paar suchen
            // Dazu durchsuchen wir das Array gemerkteKarten, bis wir in
            // beiden Dimensionen einen Wert für eine Karte finden
            while kartenZaehler < 21 && treffer == false {
                
                // Gibt es in beiden Dimensionen einen Wert größer
                // oder gleich 0?
                if gemerkteKarten[0] [kartenZaehler] >= 0 && gemerkteKarten[1] [kartenZaehler] >= 0 {
                    
                    // Dann haben wir ein Paar gefunden
                    treffer = true
                    
                    // Die erste Karte umdrehen durch einen simulierten Klick
                    // auf die Karte
                    karten[gemerkteKarten[0] [kartenZaehler]].vorderseiteZeigen()
                    // Und die Karte öffnen
                    karteOeffnen(karte: karten[gemerkteKarten[0] [kartenZaehler]])
                    
                    // Die zweite Karte auch
                    karten[gemerkteKarten[1] [kartenZaehler]].vorderseiteZeigen()
                    // Und die Karte öffnen
                    karteOeffnen(karte: karten[gemerkteKarten[1] [kartenZaehler]])
                }
                kartenZaehler = kartenZaehler + 1
            }
        }
        
        // Wenn wir kein Paar gefunden haben, drehen wir zufällig
        // zwei Karten um
        if treffer == false {
            
            // So lange eine Zufallszahl suchen, bis eine Karte gefunden
            // wird, die noch im Spiel ist
            repeat {
                zufall = Int(arc4random_uniform(42))
            } while karten[zufall].getNochImSpiel() == false
            
            // Die erste Karte umdrehen
            // und die Vorderseite zeigen
            karten[zufall].vorderseiteZeigen()
            // und die Karte öffnen
            karteOeffnen(karte: karten[zufall])
            
            // Für die zweite Karte müssen wir außerdem prüfen, ob sie
            // nicht gerade angezeigt wird
            repeat {
                zufall = Int(arc4random_uniform(42))
            } while karten[zufall].getNochImSpiel() == false || karten[zufall].getUmgedreht() == true
            
            // Und die Zweite Karte Umdrehen
            // und die Vorderseite zeigen
            karten[zufall].vorderseiteZeigen()
            // und die Karte öffnen
            karteOeffnen(karte: karten[zufall])
        }
    }
    
    // Die Methode liefert, ob Züge des Menschen erlaubt sind
    // Die Rückgabe ist false, wenn gerade der Computer zieht oder
    // wenn schon zwei Karten umgedreht sind
    // Sonst ist die Rückgabe true
    func zugErlaubt() -> Bool {
        
        var erlaubt = true
        
        // Zieht gerade der Computer?
        if spieler == 1 {
            erlaubt = false
        }
        
        // Sind schon zwei Karten umgedreht?
        if umgedrehteKarten == 2 {
            erlaubt = false
        }
        return erlaubt
    }
    
    // Die Methode ändert die Spielstärke des Computers
    func spielstaerkeVeraendern() {
        spielstaerke = labelSpielStaerke.integerValue
        
        if staerkeSlider.integerValue == 0 {
            labelSpielStaerke.stringValue = "Profi"
            spielstaerke = 0
        } else if staerkeSlider.integerValue == 2 {
            labelSpielStaerke.stringValue = "Hart"
            spielstaerke = 2
        } else if staerkeSlider.integerValue == 5 {
            labelSpielStaerke.stringValue = "Mittel"
            spielstaerke = 5
        } else if staerkeSlider.integerValue == 7 {
            labelSpielStaerke.stringValue = "Einfach"
            spielstaerke = 7
        } else if staerkeSlider.integerValue == 10 {
            labelSpielStaerke.stringValue = "Baby"
            spielstaerke = 10
        }
    }
    
    // Schummeln
    @objc func schummel() {
        for card in karten {
            
            // Deckt alle Karten wieder zu, die noch im Spiel sind
            // und umgedreht sind
            if card.getNochImSpiel() && card.getUmgedreht() {
                card.rueckseiteZeigen(rausnehmen: false)
            }
        }
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func spielStaerke(_ sender: Any) {
        spielstaerkeVeraendern()
    }
    
    @IBAction func schummelClicked(_ sender: Any) {
        // Zeigt alle Karten die noch im Spiel sind und nicht
        // umgedreht wurden
        for card in karten {
            if card.getNochImSpiel() && !card.getUmgedreht() {
                card.vorderseiteZeigen()
            }
        }
        
        // Blendet den Button aus bevor der Timer startet
        schummelButton.isEnabled = false
        
        // Setzt den Timer auf 5 Sekunden
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(schummel), userInfo: nil, repeats: false)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        for card in karten {
            card.removeFromSuperview()
            paar.removeAll()
            initMeinSpielfeld()
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Das Spielfeld aufbauen und initialisieren
        initMeinSpielfeld()
        spielstaerkeVeraendern()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

