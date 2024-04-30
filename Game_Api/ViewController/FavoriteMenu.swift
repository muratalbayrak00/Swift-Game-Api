//
//  FavoriteMenu.swift
//  Game_Api
//
//  Created by murat albayrak on 27.04.2024.
//

import UIKit



class FavoriteMenu: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteGames: [ListGamesResult] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let favoriteGamesData = UserDefaults.standard.data(forKey: "favoriteGames"),
           let decodedFavoriteGames = try? JSONDecoder().decode([ListGamesResult].self, from: favoriteGamesData) {
            self.favoriteGames = decodedFavoriteGames
            collectionView.reloadData()
            
            if favoriteGames.isEmpty && view.viewWithTag(999) == nil {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                emptyLabel.text = "Oops! You haven't\nadded any games\nto your favorites yet."
                emptyLabel.textAlignment = .center
                emptyLabel.numberOfLines = 0
                emptyLabel.tag = 999
                collectionView.backgroundView = emptyLabel
            } else {
                
                collectionView.backgroundView = nil
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
    }
    
}

extension FavoriteMenu: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCell
        cell.configure(model: favoriteGames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGame = favoriteGames[indexPath.row]
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsPageViewController {
            detailsVC.selectedGame = selectedGame
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
