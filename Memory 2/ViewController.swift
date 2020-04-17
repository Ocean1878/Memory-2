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
    
    
    
    // MARK: - Methoden
    
    
    
    // MARK: - Actions
    
    
    @IBAction func closeClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

