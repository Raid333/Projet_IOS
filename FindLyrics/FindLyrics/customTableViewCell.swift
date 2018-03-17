//
//  customTableViewCell.swift
//  FindLyrics
//
//  Created by Alexandre Normand on 07/03/2018.
//  Copyright © 2018 Alexandre Normand. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

    
    @IBOutlet weak var explicite: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
