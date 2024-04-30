//
//  DetailsPageViewController.swift
//  Game_Api
//
//  Created by murat albayrak on 25.04.2024.
//

import Foundation
import UIKit
import Kingfisher


/*

 [] search filter yap
 [] 20 den falza oyun gosterebilmeyi yap

 */


class DetailsPageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var raleasedDateLabel: UILabel!
    @IBOutlet weak var metacriticRateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isStarFilled = false
    var gameDescription: String?
    
    var gameDetails = [GameDetailsResult]()
    var  selectedGame: ListGamesResult
    var favoriteGames: [ListGamesResult] = []
    
    init(selectedGame: ListGamesResult) {
        self.selectedGame = selectedGame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.selectedGame = ListGamesResult(id: 0, name: "", released: "", rating: 0, imageUrl: "", metacritic: 0, description: "")
        super.init(coder: aDecoder)
    }
    
    func configure(model: ListGamesResult, description: String) {
        
        nameLabel.text = model.name
        raleasedDateLabel.text = model.released
        metacriticRateLabel.text = "\(model.metacritic ?? 0)"
        descriptionLabel.text = description.removeHTMLTags()
        
        guard let imageUrl = model.imageUrl, let url = URL(string: imageUrl) else {
            return
        }
        
        imageView.kf.setImage(with: url)
        
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0)
        descriptionLabel.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: descriptionLabel.frame.height)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GameLogic.shared.getGameDetails(gameID: selectedGame.id ?? 3939) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.gameDescription = games.description ?? "error"
                self.configure(model: selectedGame, description: self.gameDescription ?? "description error")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.addGestureRecognizer(tapGesture)
        
        if let data = UserDefaults.standard.data(forKey: "favoriteGames"),
           let decodedGames = try? JSONDecoder().decode([ListGamesResult].self, from: data) {
            favoriteGames = decodedGames
        }
        
        if favoriteGames.contains(where: { $0.id == selectedGame.id }) {
            favoriteIcon.image = UIImage(systemName: "star.fill")
            isStarFilled = true
        } else {
            favoriteIcon.image = UIImage(systemName: "star")
            isStarFilled = false
        }
        
    }
    
    
    @objc func imageTap() {
        
        if isStarFilled {
            favoriteIcon.image = UIImage(systemName: "star")
            isStarFilled = false
            if let index = favoriteGames.firstIndex(where: { $0.id == selectedGame.id }) {
                favoriteGames.remove(at: index)
            }
        } else {
            favoriteIcon.image = UIImage(systemName: "star.fill")
            isStarFilled = true
            favoriteGames.append(selectedGame)
        }
        
        if let encodedData = try? JSONEncoder().encode(favoriteGames) {
            UserDefaults.standard.set(encodedData, forKey: "favoriteGames")
        }
    }
    
}

extension String {
    
    func removeHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
