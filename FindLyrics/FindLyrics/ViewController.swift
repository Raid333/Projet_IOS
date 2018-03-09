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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.backItem?.title = "RETOUR"
        title = "Hello"
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
    

