//
//  RestTableViewCell.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/8.
//

import UIKit

class RestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starImgV: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var vicinityLb: UILabel!
    @IBOutlet weak var ratingLb: UILabel!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        nameLb.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(nameLb)
//        NSLayoutConstraint.activate([
//            nameLb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
//            nameLb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -25),
//            nameLb.widthAnchor.constraint(equalToConstant: contentView.frame.width - 6),
//            nameLb.heightAnchor.constraint(equalToConstant: 25)
//        ])
//
//        starImgV.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(starImgV)
//        NSLayoutConstraint.activate([
//            starImgV.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 0),
//            starImgV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
//            starImgV.widthAnchor.constraint(equalToConstant: 25),
//            starImgV.heightAnchor.constraint(equalToConstant: 25)
//        ])
//
//        ratingLb.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(ratingLb)
//        NSLayoutConstraint.activate([
//            ratingLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 0),
//            ratingLb.leadingAnchor.constraint(equalTo: starImgV.trailingAnchor, constant: -6),
//            ratingLb.widthAnchor.constraint(equalToConstant: 25),
//            ratingLb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])
//
//        vicinityLb.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(vicinityLb)
//        NSLayoutConstraint.activate([
//            vicinityLb.topAnchor.constraint(equalTo: nameLb.bottomAnchor, constant: 0),
//            vicinityLb.leadingAnchor.constraint(equalTo: ratingLb.trailingAnchor, constant: -6),
//            vicinityLb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            vicinityLb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLb.adjustsFontSizeToFitWidth = true
        starImgV.image = UIImage(named: "star")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}
