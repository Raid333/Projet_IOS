//
//  LyricsCustomCellule.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 09/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class LyricsCustomCellule: UITableViewCell {

    @IBOutlet weak var Lyrics_body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
