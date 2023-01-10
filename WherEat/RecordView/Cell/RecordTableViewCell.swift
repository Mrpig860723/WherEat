//
//  RecordTableViewCell.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/10.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var restImgV: UIImageView!
    @IBOutlet weak var restNameLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
