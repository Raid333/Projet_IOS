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
        
        
        let apiKey = "3268eb1f943b699a9085beaede770116"
        var url = "http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=\(paroles)&page_size=20&page=1&s_track_rating=desc&apikey=\(apiKey)"
        
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
        
        /*
        let apiKey = "3268eb1f943b699a9085beaede770116"
        var parole = "test"
        var url = "http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=\(parole)&page_size=20&page=1&s_track_rating=desc&apikey=\(apiKey)"
        
        if let url = URL(string: "\(url)"){
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
                    
                    return
                }
                
                do{
                    let root = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if (type == 1) {
                        
                        if let rootDict = root as? [String : Any]{
                            if let feed = rootDict["message"] as? [String : Any]{
                                
                                if let header = feed["header"] as? [String : Any] {
                                    if let status_code = header["status_code"] as? Int {
                                        print (status_code)
                                    }
                                }
                                if let body = feed["body"] as? [String : Any] {
                                    if (type == 1) {
                                        
                                    } else {
                                        if let lyrics = body["lyrics"] as? [String : Any] {
                                            var listeLyric = Lyric()
                                            if let lyrics_body = lyrics["lyrics_body"] as? String {
                                                // ajouter aux paroles
                                                print ("LYRIC : ")
                                                listeLyric.body = lyrics_body
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }//end rootdict
                    }
                    
                    
                    
                    //Callback sur l'interface graphique (1)
                    //                    impossibilité d'utiliser l'interface graphique en dehors du thread principal
                    DispatchQueue.main.async {
                        self.delegate!.dataLoaded(datas : self.datas)
                        self.delegate2!.dataLoaded2(datas2 : self.datas2)
                    }
                }
                catch{
                }
            }).resume()
        }
 */
        
        return false
    }
    
    public func loadLyrics(trackID : Int) ->Bool
    {
        // Récupération paroles en fonction de la "track_id"
        
        let apiKey = "3268eb1f943b699a9085beaede770116"
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
//class DataBaseController: NSObject {
//    var delegate : DBDelegate? = nil
//    
//    var datas = Track_list()
//    var datas2 = Lyric_list()
//    
//    func load(type : Int) -> Bool {
//        loadData(type: type)
//        return false
//    }
//    
//    
//    func loadData(type: Int){
//        
//        // Pour le recherche de musiques le type doit être égal à 1
//        // Pour la recherche de paroles, le type doit être égal à 2
//        // A voir pour la suite...
//        let apiKEY = "3268eb1f943b699a9085beaede770116"
//        
//        var search = ""
//        var typeUrl = ""
//        var url = ""
//        var trackID = ""
//        var typeSearch = ""
//        
//        if (type == 1) {
//            search = "pute"
//            typeSearch = "q_lyrics"
//            typeUrl = "track.search"
//            url = "http://api.musixmatch.com/ws/1.1/\(typeUrl)?\(typeSearch)=\(search)&page_size=20&page=1&s_track_rating=desc&apikey=\(apiKEY)"
//        } else {
//            trackID = "15953433"
//            typeUrl = "track.lyrics.get"
//            url = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(trackID)&apikey=\(apiKEY)"
//        }
////        let search = "pute"
////        let typeSearch = "q_lyrics"
////        let typeUrl = "track.search"
////
//        // OPTIONS
////        q_track => The song title
////        q_artist => The song artist
////        q_lyrics => Any word in the lyrics
////        q_track_artist =>Any word in the song title or artist name
////        q =>Any word in the song title or artist name or lyrics
////        f_artist_id => When set, filter by this artist id
////        f_music_genre_id => When set, filter by this music category id
////        f_lyrics_language => Filter by the lyrics language (en,it,..)
////        f_has_lyrics => When set, filter only contents with lyrics
////        f_track_release_group_first_release_date_min => When set, filter the tracks with release date newer than value, format is YYYYMMDD
////        f_track_release_group_first_release_date_max => When set, filter the tracks with release date older than value, format is YYYYMMDD
////        s_artist_rating => Sort by our popularity index for artists (asc|desc)
////        s_track_rating => Sort by our popularity index for tracks (asc|desc)
////        quorum_factor => Search only a part of the given query string.Allowed range is (0.1 – 0.9)
////        page => Define the page number for paginated results
////        page_size => Define the page size for paginated results. Range is 1 to 100.
//        
//        if let url = URL(string: "\(url)"){
////            print (url)
//            
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                
//                /*
//                 // transfert des données sur le fil principal
//                 DispatchQueue.main.async {
//                 self.label!.text = "error"
//                 }
//                 */
//                guard let data = data , error == nil else
//                {
//                    DispatchQueue.main.async {
//                        self.delegate!.dataLoaded(datas : nil)
//                    }
//                    return
//                }
//                
//                do{
//                    let root = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                    
//                    if (type == 1) {
//                    
//                    if let rootDict = root as? [String : Any]{
//                        if let feed = rootDict["message"] as? [String : Any]{
//                            
//                            if let header = feed["header"] as? [String : Any] {
//                                if let status_code = header["status_code"] as? Int {
//                                    print (status_code)
//                                }
//                            }
//                            if let body = feed["body"] as? [String : Any] {
//                                if (type == 1) {
//                                if let tracks = body["track_list"] as? [ [ String : Any ] ] {
//                                    for track in tracks {
//                                        var listeMusique = Track()
//                                        if let musique = track["track"] as? [ String : Any ] {
//                                            if let musiqueID = musique["track_id"] as? Int {
//                                                listeMusique.id = musiqueID
////                                                print ("ID : \(musiqueID)")
//                                            }
//                                            if let titre = musique["track_name"] as? String {
//                                                listeMusique.name = titre
////                                                print ("TITRE : \(titre)")
//                                            }
//                                            if let artiste = musique["artist_name"] as? String {
//                                                listeMusique.artist = artiste
////                                                print ("ARTISTE : \(artiste)")
//                                            }
//                                            if let album = musique["album_name"] as? String {
//                                                listeMusique.album = album
//                                            }
//                                            
//                                        }// end for musique
//                                        
//                                        // voir pour l'ajout de musqiue dans le tableau (bdd)
//                                    self.datas.track.append(listeMusique)
//                                    }
//                                    
//                                }//end for body
//                                } else {
//                                    if let lyrics = body["lyrics"] as? [String : Any] {
//                                        var listeLyric = Lyric()
//                                        if let lyrics_body = lyrics["lyrics_body"] as? String {
//                                            // ajouter aux paroles
//                                            print ("LYRIC : ")
//                                            listeLyric.body = lyrics_body
//                                        }
//                                        
//                                    }
//                                }
//                            }
//                            
//                        }
//                        
//                    }//end rootdict
//                    }
//                    
//                    
//                    
//                    //Callback sur l'interface graphique (1)
//                    //                    impossibilité d'utiliser l'interface graphique en dehors du thread principal
//                    DispatchQueue.main.async {
//                        self.delegate!.dataLoaded(datas : self.datas)
//                    }
//                }
//                catch{
//                }
//            }).resume()
//        }// end if
//    }
//}

