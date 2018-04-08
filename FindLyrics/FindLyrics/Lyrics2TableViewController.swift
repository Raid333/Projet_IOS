//
//  Lyrics2TableViewController.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 03/04/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class Lyrics2TableViewController: UITableViewController, DBDelegate {
    
    
    @IBOutlet weak var afficheLyrics: UITextView!
    var indexTrack = -1
    var typeSegue = -1
    var trackName = ""
    let dbController = DataBaseController.shared
    
    func dataLoaded(datas: Track_list?)
    {
        guard let datas = datas else {
            print ("error data")
            
            let alertController = UIAlertController(title: "Erreur", message:
                "Problème de connexion", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        //tableView.reloadData()
        if (typeSegue == 1) {
            let trackid = dbController.datas.artistTrack[indexTrack].id
            let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
            self.afficheLyrics.attributedText = attributed
            afficheLyrics.font = .systemFont(ofSize: 17)
        } else {
            let trackid = dbController.datas.albumTrack[indexTrack].id
            let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
            self.afficheLyrics.attributedText = attributed
            afficheLyrics.font = .systemFont(ofSize: 17)
        }
        //        labelLyrics.text = dbController.datas.lyric[trackid]?.body
        
        
        //        viewLyrics.text = searchKeyWord(with: "\(dbController.datas.lyric[trackid]?.body)", word: "\(message)")
        
        
        print ("lyrics ok")
        navigationItem.title = "\(trackName)"
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 1000
        print (indexTrack)
        assert(indexTrack >= 0)
        print (typeSegue)
        
        
        if (typeSegue == 1) {
            let track = dbController.datas.artistTrack[indexTrack]
            if let lyrics = dbController.datas.lyric[track.id]
            {
                let trackid = dbController.datas.artistTrack[indexTrack].id
                //            viewLyrics.text = searchKeyWord(with: "\(dbController.datas.lyric[trackid]?.body)", word: "\(message)")
                let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
                self.afficheLyrics.attributedText = attributed
                afficheLyrics.font = .systemFont(ofSize: 17)
                
            } else {
                dbController.delegate = self
                if dbController.loadLyrics(trackID: track.id) == false {
                    // print ("Error dbController.load")
                }
            }
        } else {
            let track = dbController.datas.albumTrack[indexTrack]
            if let lyrics = dbController.datas.lyric[track.id]
            {
                let trackid = dbController.datas.albumTrack[indexTrack].id
                //            viewLyrics.text = searchKeyWord(with: "\(dbController.datas.lyric[trackid]?.body)", word: "\(message)")
                let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
                self.afficheLyrics.attributedText = attributed
                afficheLyrics.font = .systemFont(ofSize: 17)
                
            } else {
                dbController.delegate = self
                if dbController.loadLyrics(trackID: track.id) == false {
                    // print ("Error dbController.load")
                }
            }
        }
        

//        navigationItem.title = track.name
    }
//
//
//
//    @IBOutlet weak var afficheLyrics: UITextView!
//    var trackName = ""
//    var trackID = -1
//    var typeSegue = ""
//    let dbController = DataBaseController.shared
//    func dataLoaded(datas: Track_list?) {
//        guard let datas = datas else {
//            print ("error data")
//
//            let alertController = UIAlertController(title: "Erreur", message:
//                "Problème de connexion", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//
//            return
//        }
//        //tableView.reloadData()
////        let trackid = dbController.datas.albumTrack[indexTrack].id
//
//        print (trackID)
//        print (dbController.datas.albumLyric.count)
////        let attributed = NSMutableAttributedString(string: (dbController.datas.albumLyric[trackID]?.body))
////        self.afficheLyrics.attributedText = attributed
////        print(attributed)
//
//        print ("lyrics ok")
//    }
//
//    //Déclaration interface
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.rowHeight = 1000
////        print (indexTrack)
////        assert(indexTrack >= 0)
////        let track = dbController.datas.albumTrack[indexTrack]
//
//        if let lyrics = dbController.datas.albumLyric[trackID]
//        {
//        let trackid = dbController.datas.albumTrack[trackID].id
//        dbController.delegate = self
//        if dbController.loadLyrics(trackID: trackid, typeLyrics: 2) == false {
//            // print ("Error dbController.load")
//        }
//            let attributed = NSMutableAttributedString(string: (dbController.datas.albumLyric[trackID]?.body)!)
//            afficheLyrics.attributedText = attributed
//            print (trackID)
//
//        } else {
//            dbController.delegate = self
//            if dbController.loadLyrics(trackID: trackID, typeLyrics: 1) == false {
//                // print ("Error dbController.load")
//            }
//        }
//        print (dbController.datas.albumLyric.count)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
