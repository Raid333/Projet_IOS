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


class DataBaseController: NSObject
    
{
    let apiKey = "3268eb1f943b699a9085beaede770116"
    var delegate : DBDelegate? = nil
    
    var datas = Track_list()
    
    static let shared = DataBaseController()
    
    private override init() {

    }
    
    private func musicMatchRequest( url : String , callback : @escaping ( [String : Any]? )-> Swift.Void) -> Bool
    {
        
//        http://api.musixmatch.com/ws/1.1/track.search?q_artist=justin%20bieber&page_size=3&page=1&s_track_rating=desc&apikey=3268eb1f943b699a9085beaede770116
        if let url = URL(string: "\(url)")
        {
            //            print (url)
            
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
                    callback(nil)
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
                                callback(body)
                            }
                        }
                    }
                }
                catch
                {
                    
                }
            }).resume()
            
            return true
        }
        
        return false
    }
    
    public func loadTracks(paroles : String) -> Bool
    {
        var i = 0
        
        //for word in words {
        var url = "http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=\(paroles)&page_size=100&quorum_factor=1&page=1&s_track_rating=desc&apikey=\(apiKey)"
        
        if( musicMatchRequest(url : url , callback: { (body) in
            
            guard let body = body else
            {
                return
            }
            i += 1
            print (i)
            print (url)
            if let tracks = body["track_list"] as?  [[ String : Any ]]  {
               for track in tracks {
                    var listeMusique = Track()
                    if let musique = track["track"] as? [ String : Any ] {
                        if let musiqueID = musique["track_id"] as? Int {
                            listeMusique.id = musiqueID
                            //  print ("ID : \(musiqueID)")
                        }
                        if let titre = musique["track_name"] as? String {
                            listeMusique.name = titre
                            // print ("TITRE : \(titre)")
                        }
                        if let artiste = musique["artist_name"] as? String {
                            listeMusique.artist = artiste
                            // print ("ARTISTE : \(artiste)")
                        }
                        if let album = musique["album_name"] as? String {
                            listeMusique.album = album
                        }
                        if let explicite = musique["explicit"] as? Int {
                            listeMusique.explicite = explicite
                        }
                        if let albumID = musique["album_id"] as? Int {
                            listeMusique.albumID = albumID
                        }
                        if let artistID = musique["artist_id"] as? Int {
                            listeMusique.artistID = artistID
                        }
                        
                    }// end for musique
                    
                    // voir pour l'ajout de musique dans le tableau (bdd)
                    
                    self.datas.track.append(listeMusique)
                }
                
            }//end for body
            DispatchQueue.main.async {
                self.delegate!.dataLoaded(datas : self.datas)
            }
            
        }))
        {
            
        }
        
        
        //}
        return false
        
    }
    
    public func loadArtist(artisteID : Int, taille : Int) -> Bool
    {
            var url = "http://api.musixmatch.com/ws/1.1/track.search?f_artist_id=\(artisteID)&page_size=\(taille)&page=1&s_track_rating=desc&apikey=\(apiKey)"
            
            if( musicMatchRequest(url : url , callback: { (body) in
                
                guard let body = body else
                {
                    return
                }
                if let tracks = body["track_list"] as? [ [ String : Any ] ] {
                    for track in tracks {
                        var listeMusique = Track()
                        if let musique = track["track"] as? [ String : Any ] {
                            if let musiqueID = musique["track_id"] as? Int {
                                listeMusique.id = musiqueID
//                                  print ("ID : \(musiqueID)")
                            }
                            if let titre = musique["track_name"] as? String {
                                listeMusique.name = titre
                                // print ("TITRE : \(titre)")
                            }
                            if let artiste = musique["artist_name"] as? String {
                                listeMusique.artist = artiste
                                // print ("ARTISTE : \(artiste)")
                            }
                            if let album = musique["album_name"] as? String {
                                listeMusique.album = album
                            }
                            if let explicite = musique["explicit"] as? Int {
                                listeMusique.explicite = explicite
                            }
                            
                        }// end for musique
                        
                        // voir pour l'ajout de musique dans le tableau (bdd)
                        
                        self.datas.artistTrack.append(listeMusique)
                    }
                    
                }//end for body
                DispatchQueue.main.async {
                    self.delegate!.dataLoaded(datas : self.datas)
                }
                
            }))
            {
                
            }
        return false
        
    }
    
    public func loadAlbum(albumID : Int) -> Bool
    {

        var url = "http://api.musixmatch.com/ws/1.1/album.tracks.get?album_id=\(albumID)&apikey=\(apiKey)"
        if( musicMatchRequest(url : url , callback: { (body) in
            
            guard let body = body else
            {
                return
            }
            if let tracks = body["track_list"] as? [ [ String : Any ] ] {
                for track in tracks {
                    var listeMusique = Track()
                    if let musique = track["track"] as? [ String : Any ] {
                        if let musiqueID = musique["track_id"] as? Int {
                            listeMusique.id = musiqueID
//                             print ("ID : \(musiqueID)")
                        }
                        if let titre = musique["track_name"] as? String {
                            listeMusique.name = titre
                            // print ("TITRE : \(titre)")
                        }
                        if let artiste = musique["artist_name"] as? String {
                            listeMusique.artist = artiste
//                             print ("ARTISTE album : \(artiste)")
                        }
                        if let album = musique["album_name"] as? String {
                            listeMusique.album = album
                        }
                        
                    }// end for musique
                    
                    // voir pour l'ajout de musique dans le tableau (bdd)
                    
                    self.datas.albumTrack.append(listeMusique)
                }
                
            }//end for body
            DispatchQueue.main.async {
                self.delegate!.dataLoaded(datas : self.datas)
            }
            
        }))
        {
            
        }
        return false
        
    }
    
    
    public func loadLyrics(trackID : Int) ->Bool
    {
        //Doc type Lyrics :
//        1 -> Lyrics recherchées / 2 -> Album lyrics / 3 -> Artist Lyrics
        
        // Récupération paroles en fonction de la "track_id"
//        var trackID = ""
        var url = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(trackID)&apikey=\(apiKey)"
//        print (url)
        
        if (musicMatchRequest( url : url , callback: { (body) in
            guard let body = body else {
                return
            }
            if let lyrics = body["lyrics"] as? [String : Any] {
                var listeLyric = Lyric()
                if let lyrics_body = lyrics["lyrics_body"] as? String {
                    // ajouter aux paroles
                    listeLyric.body = lyrics_body
//                    print (lyrics_body)
//                    print (listeLyric.body)
                    self.datas.lyric[trackID] = listeLyric
                }
                
            }//end body
            
            DispatchQueue.main.async {
                self.delegate!.dataLoaded(datas : self.datas)
            }
            
//            self.datas.lyric.append(listeLyric)
            //append sur la table lyrics
            
        }))
        {
            
        }
        return false
    }
}

