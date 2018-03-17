//
//  ViewController.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 07/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lyricName: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let lyric = lyricName.text, !lyric.isEmpty
            else {
                self.searchButton.isEnabled = false
                return
        }
        self.searchButton.isEnabled = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.backItem?.title = "RETOUR"
        title = "Trouves Tes Paroles"
        lyricName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        
        searchButton.isEnabled = false
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "lyricName" {
                let TrackController = segue.destination as! TableViewController
                TrackController.message = self.lyricName.text!
            }
            
        }
    
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

