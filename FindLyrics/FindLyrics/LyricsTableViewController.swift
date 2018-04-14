//
//  LyricsTableViewController.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 08/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class LyricsTableViewController: UITableViewController, DBDelegate {
    var message = ""
    
    func searchKeyWord(with body: String, word: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: body)
        do
        {
            let regex = try! NSRegularExpression(pattern: word,options: .caseInsensitive)
            for match in regex.matches(in: body, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: body.characters.count)) as [NSTextCheckingResult] {
                attributed.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.yellow, range: match.range)
            }
            return attributed
        }
    }

    @IBOutlet weak var viewLyrics: UITextView!
    @IBOutlet weak var nomArtiste: UIButton!
    @IBOutlet weak var nomAlbum: UIButton!
    
    
    var indexTrack = -1
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
        let trackid = dbController.datas.track[indexTrack].id
//        labelLyrics.text = dbController.datas.lyric[trackid]?.body
        let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
        let regex = try! NSRegularExpression(pattern: message,options: .caseInsensitive)
        for match in regex.matches(in: (dbController.datas.lyric[trackid]?.body)!, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: (dbController.datas.lyric[trackid]?.body.characters.count)!)) as [NSTextCheckingResult] {
            attributed.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.magenta, range: match.range)
        }
        self.viewLyrics.attributedText = attributed
        viewLyrics.font = .systemFont(ofSize: 17)
//        viewLyrics.text = searchKeyWord(with: "\(dbController.datas.lyric[trackid]?.body)", word: "\(message)")
        
        
        print ("lyrics ok")
        
        }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 1000
        print (indexTrack)
        assert(indexTrack >= 0)
        
        let track = dbController.datas.track[indexTrack]
        
        
        
        if let lyrics = dbController.datas.lyric[track.id]
        {
            
            let trackid = dbController.datas.track[indexTrack].id
//            viewLyrics.text = searchKeyWord(with: "\(dbController.datas.lyric[trackid]?.body)", word: "\(message)")
            let attributed = NSMutableAttributedString(string: (dbController.datas.lyric[trackid]?.body)!)
            let regex = try! NSRegularExpression(pattern: message,options: .caseInsensitive)
            for match in regex.matches(in: (dbController.datas.lyric[trackid]?.body)!, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: (dbController.datas.lyric[trackid]?.body.characters.count)!)) as [NSTextCheckingResult] {
                attributed.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.magenta, range: match.range)
            }
            self.viewLyrics.attributedText = attributed
            viewLyrics.font = .systemFont(ofSize: 17)
            
        } else {
            dbController.delegate = self
            if dbController.loadLyrics(trackID: track.id) == false {
                // print ("Error dbController.load")
            }
        }
        navigationItem.title = track.name
        nomArtiste.setTitle(track.artist, for: .normal)
        nomArtiste.setTitleColor(UIColor.purple, for: .normal)
        nomAlbum.setTitleColor(UIColor.purple, for: .normal)
        nomAlbum.setTitle(track.album, for: .normal)
        
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

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1// dbController.datas.lyric.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricCellule", for: indexPath) as! LyricsCustomCellule
        
//        cell.textLabel?.text = dbController.datas.lyric[ indexPath.row ].body
        
        let trackId = dbController.datas.track[indexTrack].id
        cell.Lyrics_body.text = dbController.datas.lyric[trackId]?.body
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artiste" {
        let viewController = segue.destination as! ArtistTableViewController
        viewController.artistID = self.dbController.datas.track[indexTrack].artistID
        viewController.artistNAME = self.dbController.datas.track[indexTrack].artist
        } else if segue.identifier == "album" {
            let viewController = segue.destination as! AlbumTableViewController
            viewController.albumID = self.dbController.datas.track[indexTrack].albumID
            viewController.albumNAME = self.dbController.datas.track[indexTrack].album
        }
    }

}
