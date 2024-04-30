//
//  GameViewController.swift
//  Game_Api
//
//  Created by murat albayrak on 26.04.2024.
//

import UIKit
import Kingfisher

class GameViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var gameList = [ListGamesResult]()
    var remainingGames = [ListGamesResult]()
    var topGameList = [ListGamesResult]()
    lazy var filteredGames = [ListGamesResult]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let photo1ImageView: UIImageView = UIImageView()
    let photo2ImageView: UIImageView = UIImageView()
    let photo3ImageView: UIImageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GameLogic.shared.getListGames { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let games):
                self.gameList = games.results ?? [ListGamesResult]()
                self.reloadData()
                setupScrollView()
            case .failure(let error):
                print(error.localizedDescription)
            }
            remainingGames = Array(self.gameList.dropFirst(3))
        }
        
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureSearchController()
        
    }
    
    private func filterContextForSearchtext(_ searchText: String) {
        filteredGames = gameList.filter({ game -> Bool in
            return game.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        collectionView.reloadData()
    }
    
    private func configureSearchController() {
        
        searchController.searchBar.placeholder = "Search Game"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setupScrollView() {
        
        self.topGameList = Array(gameList.prefix(3))
        
        guard let img = topGameList[0].imageUrl, let url = URL(string: img) else { return }
        guard let img2 = topGameList[1].imageUrl, let url2 = URL(string: img2) else { return }
        guard let img3 = topGameList[2].imageUrl, let url3 = URL(string: img3) else { return }
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        photo1ImageView.kf.setImage(with: url)
        photo2ImageView.kf.setImage(with: url2)
        photo3ImageView.kf.setImage(with: url3)
        
        let scrollViewWidth = scrollView.frame.width
        let scrollViewHeight = scrollView.frame.height
        
        photo1ImageView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        photo2ImageView.frame = CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        photo3ImageView.frame = CGRect(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        
        scrollView.addSubview(photo1ImageView)
        scrollView.addSubview(photo2ImageView)
        scrollView.addSubview(photo3ImageView)
        
        scrollView.contentSize = CGSize(width: scrollViewWidth * 3, height: scrollViewHeight)
        
        let labelHeight: CGFloat = 30
        let labelYPosition = scrollView.frame.height - labelHeight
        
        let nameLabel1 = UILabel(frame: CGRect(x: 0, y: labelYPosition, width: scrollView.frame.width, height: labelHeight))
        let nameLabel2 = UILabel(frame: CGRect(x: scrollView.frame.width, y: labelYPosition, width: scrollView.frame.width, height: labelHeight))
        let nameLabel3 = UILabel(frame: CGRect(x: scrollView.frame.width * 2, y: labelYPosition, width: scrollView.frame.width, height: labelHeight))
        
        nameLabel1.text = topGameList[0].name
        nameLabel2.text = topGameList[1].name
        nameLabel3.text = topGameList[2].name
        
        nameLabel1.textAlignment = .center
        nameLabel2.textAlignment = .center
        nameLabel3.textAlignment = .center
        
        nameLabel1.backgroundColor = .white
        nameLabel2.backgroundColor = .white
        nameLabel3.backgroundColor = .white
        
        scrollView.addSubview(nameLabel1)
        scrollView.addSubview(nameLabel2)
        scrollView.addSubview(nameLabel3)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(photo1Tapped))
        photo1ImageView.isUserInteractionEnabled = true
        photo1ImageView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(photo2Tapped))
        photo2ImageView.isUserInteractionEnabled = true
        photo2ImageView.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(photo3Tapped))
        photo3ImageView.isUserInteractionEnabled = true
        photo3ImageView.addGestureRecognizer(tapGesture3)
    }
    
    @objc func photo1Tapped() {
        guard let tappedGame = topGameList.first else { return }
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsPageViewController {
            detailsVC.selectedGame = tappedGame
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    @objc func photo2Tapped() {
        guard topGameList.count >= 2 else { return }
        let tappedGame = topGameList[1]
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsPageViewController {
            detailsVC.selectedGame = tappedGame
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    @objc func photo3Tapped() {
        guard topGameList.count >= 3 else { return }
        let tappedGame = topGameList[2]
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsPageViewController {
            detailsVC.selectedGame = tappedGame
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    
}

protocol GameViewControllerProtocol {
    func loadMovieListCollectionView()
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGames.count
        }
        return remainingGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCell
        
        if isFiltering {
            cell.configure(model: filteredGames[indexPath.row])
        } else {
            cell.configure(model: remainingGames[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedGame = remainingGames[indexPath.row]
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsPageViewController {
            detailsVC.selectedGame = selectedGame
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}

extension GameViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        // TODO: guard searchText.count >= 3 else { return }
        
        filterContextForSearchtext(searchText)
        checkEmptySearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearFilteredGames()
        checkEmptySearch()
    }
    
    private func clearFilteredGames() {
        filteredGames.removeAll()
        collectionView.reloadData()
    }
    
    func checkEmptySearch() {
        
        if isFiltering && filteredGames.isEmpty {
            collectionView.isHidden = true
            scrollView.isHidden = true
            showEmptySearchMessage()
        } else {
            collectionView.isHidden = false
            scrollView.isHidden = false
            removeEmptySearchMessage()
        }
        
    }
    
    func showEmptySearchMessage() {
        let message = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        message.text = "Sorry, the game you are looking for could not be found!"
        message.textColor = .black
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont(name: "HelveticaNeue", size: 20)
        message.sizeToFit()
        message.center = view.center
        view.addSubview(message)
        view.bringSubviewToFront(message)
    }
    
    func removeEmptySearchMessage() {
        for subview in view.subviews {
            if let message = subview as? UILabel,  message.text == "Sorry, the game you are looking for could not be found!" {
                message.removeFromSuperview()
            }
        }
    }
}
