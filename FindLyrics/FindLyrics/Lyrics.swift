//
//  Lyrics.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 05/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class Track {
    var id = 0
    var name = ""
    var artist = ""
    var artistID = 0
    var album = ""
    var albumID = 0
}

class Lyric {
    var id = 0
    var body = ""
}

class Track_list {
    var track = [Track]()
    var lyric = [ Int : Lyric]()
}

//class Lyric_list {
//    var lyric = [Lyric]()
//}

