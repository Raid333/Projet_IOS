//
//  ArtistTableViewController.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 03/04/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class ArtistTableViewController: UITableViewController, DBDelegate {
        var artistID = 0
        var artistNAME = ""
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
        navigationItem.title = "Artiste : \"\(artistNAME)\""
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (artistID)
        tableView.rowHeight = 100
        dbController.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if (dbController.datas.artistTrack.count != 0) {dbController.datas.artistTrack.removeAll() }
        
        if dbController.loadArtist(artisteID: artistID, taille: 20) == false {
            //  print ("Error dbController.load")
        }
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
        return dbController.datas.artistTrack.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellule", for: indexPath) as! customTableViewCell
        cell.title.text = dbController.datas.artistTrack[ indexPath.row ].name
        cell.artist.text = dbController.datas.artistTrack[ indexPath.row ].artist
        cell.album.text = dbController.datas.artistTrack[ indexPath.row ].album
        if (dbController.datas.artistTrack[ indexPath.row ].explicite == 1) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "artistSEGUE" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! Lyrics2TableViewController
                viewController.indexTrack =  indexPath.row
                viewController.typeSegue = 1
                viewController.trackName = self.dbController.datas.artistTrack[indexPath.row].name
            }
            
        }
    }

}
