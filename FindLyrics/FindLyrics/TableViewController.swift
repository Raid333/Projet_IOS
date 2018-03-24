//
//  TableViewController.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 08/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController , DBDelegate{
    
    var message = ""
    let dbController = DataBaseController.shared
    func dataLoaded(datas: Track_list?) {
        guard let datas = datas else {
            print ("error data")
            
            let alertController = UIAlertController(title: "Erreur", message:
                "Problème de connexion", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        tableView.reloadData()
        print ("tracks ok")
        navigationItem.prompt = "\(dbController.datas.track.count) résultat(s)"
        navigationItem.title = "Mot clé : \"\(message)\""
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Comptage des mots recherchés
        let components = message.components(separatedBy: .whitespacesAndNewlines)
        let wordCount = components.filter{ !$0.isEmpty }.count
        let words = components.filter{ !$0.isEmpty }
//        print (spaceCount)
        print (message)
//        for mot in spaceCount {
//                print (mot)
//        }
        
        tableView.rowHeight = 100
        dbController.delegate = self
        
        
        if (dbController.datas.track.count != 0) {dbController.datas.track.removeAll() }
        
        if dbController.loadTracks(paroles : message) == false {
          //  print ("Error dbController.load")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dbController.datas.track.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellule", for: indexPath) as! customTableViewCell
        cell.title.text = dbController.datas.track[ indexPath.row ].name
        cell.artist.text = dbController.datas.track[ indexPath.row ].artist
        cell.album.text = dbController.datas.track[ indexPath.row ].album
        if (dbController.datas.track[ indexPath.row ].explicite == 1) {
            cell.explicite.image = UIImage (named : "explicite.png")
        }
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
        if segue.identifier == "trackID" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let viewController = segue.destination as! LyricsTableViewController
                viewController.indexTrack =  indexPath.row
                viewController.message = self.message
            }
            
        }

     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}

