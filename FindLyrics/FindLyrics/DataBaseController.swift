//
//  DataBaseController.swift
//  Parcing JSON
//
//  Created by Alexandre Normand on 22/01/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

protocol DBDelegate {
    func dataLoaded( datas : Track_list? )
}

class DataBaseController: NSObject {
    var delegate : DBDelegate? = nil
    
    var datas = Track_list()
    
    
    func load() -> Bool {
        loadData()
        return false
    }
    
    
    func loadData(){
        
        
        let search = "pute"
        let typeSearch = "q_lyrics"
        
        // OPTIONS
//        q_track => The song title
//        q_artist => The song artist
//        q_lyrics => Any word in the lyrics
//        q_track_artist =>Any word in the song title or artist name
//        q =>Any word in the song title or artist name or lyrics
//        f_artist_id => When set, filter by this artist id
//        f_music_genre_id => When set, filter by this music category id
//        f_lyrics_language => Filter by the lyrics language (en,it,..)
//        f_has_lyrics => When set, filter only contents with lyrics
//        f_track_release_group_first_release_date_min => When set, filter the tracks with release date newer than value, format is YYYYMMDD
//        f_track_release_group_first_release_date_max => When set, filter the tracks with release date older than value, format is YYYYMMDD
//        s_artist_rating => Sort by our popularity index for artists (asc|desc)
//        s_track_rating => Sort by our popularity index for tracks (asc|desc)
//        quorum_factor => Search only a part of the given query string.Allowed range is (0.1 – 0.9)
//        page => Define the page number for paginated results
//        page_size => Define the page size for paginated results. Range is 1 to 100.
        
        if let url = URL(string: "http://api.musixmatch.com/ws/1.1/track.search?\(typeSearch)=\(search)&page_size=20&page=1&s_track_rating=desc&apikey=3268eb1f943b699a9085beaede770116"){
            
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                /*
                 // transfert des données sur le fil principal
                 DispatchQueue.main.async {
                 self.label!.text = "error"
                 }
                 */
                guard let data = data , error == nil else
                {
                    DispatchQueue.main.async {
                        self.delegate!.dataLoaded(datas : nil)
                    }
                    return
                }
                
                do{
                    let root = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let rootDict = root as? [String : Any]{
                        if let feed = rootDict["message"] as? [String : Any]{
                            
                            if let header = feed["header"] as? [String : Any] {
                                if let status_code = header["status_code"] as? Int {
                                    print (status_code)
                                }
                            }
                            if let body = feed["body"] as? [String : Any] {
                                
                                if let tracks = body["track_list"] as? [ [ String : Any ] ] {
                                    for track in tracks {
                                        var listeMusique = Track()
                                        if let musique = track["track"] as? [ String : Any ] {
                                            if let musiqueID = musique["track_id"] as? Int {
                                                listeMusique.id = musiqueID
//                                                print ("ID : \(musiqueID)")
                                            }
                                            if let titre = musique["track_name"] as? String {
                                                listeMusique.name = titre
//                                                print ("TITRE : \(titre)")
                                            }
                                            if let artiste = musique["artist_name"] as? String {
                                                listeMusique.artist = artiste
//                                                print ("ARTISTE : \(artiste)")
                                            }
                                            
                                        }// end for musique
                                        
                                        // voir pour l'ajout de musqiue dans le tableau (bdd)
                                    self.datas.track.append(listeMusique)
                                    }
                                    
                                }//end for body
                            }
                            
                        }
                        
                    }//end rootdict
                    //Callback sur l'interface graphique (1)
                    //                    impossibilité d'utiliser l'interface graphique en dehors du thread principal
                    DispatchQueue.main.async {
                        self.delegate!.dataLoaded(datas : self.datas)
                    }
                }
                catch{
                }
            }).resume()
        }// end if
    }
}

