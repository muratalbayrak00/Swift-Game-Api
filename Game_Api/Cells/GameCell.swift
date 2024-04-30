//
//  GameCell.swift
//  Game_Api
//
//  Created by murat albayrak on 26.04.2024.
//

import UIKit
import Kingfisher

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var nameOfGameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var ratingReleasedLabel: UILabel!
    
    func configure(model: ListGamesResult) {
        nameOfGameLabel.text = model.name
        let releasedText = model.released ?? ""
        let ratingText = model.rating.map { "\($0) ⭐️" } ?? ""
        ratingReleasedLabel.text = "\(ratingText)              \(releasedText)"
        guard var imageUrl = model.imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        gameImage.kf.setImage(with: url)
    }
}
