//
//  TblCell.swift
//  MapView
//
//  Created by Mac Mini Old on 07/12/18.
//  Copyright © 2018 Mac Mini Old. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {

    @IBOutlet var LblLocationname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }

}
