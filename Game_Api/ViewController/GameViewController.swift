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
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var gameList = [ListGamesResult]()
    var remainingGames = [ListGamesResult]()
    var topGameList = [ListGamesResult]()
    
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
    
    func reloadData() {
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
    
    func configureSearchController() {
        
        searchController.searchBar.placeholder = "Search User"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setupScrollView() {
        
        self.topGameList = Array(gameList.prefix(3))
        
        guard var img = topGameList[0].imageUrl, let url = URL(string: img) else { return }
        guard var img2 = topGameList[1].imageUrl, let url2 = URL(string: img2) else { return }
        guard var img3 = topGameList[2].imageUrl, let url3 = URL(string: img3) else { return }
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
        let dateAndRatingLabel1 = UILabel(frame: CGRect(x: 0, y: labelYPosition + labelHeight, width: scrollView.frame.width, height: labelHeight))
        
        let nameLabel2 = UILabel(frame: CGRect(x: scrollView.frame.width, y: labelYPosition, width: scrollView.frame.width, height: labelHeight))
        let dateAndRatingLabel2 = UILabel(frame: CGRect(x: scrollView.frame.width, y: labelYPosition + labelHeight, width: scrollView.frame.width, height: labelHeight))
        
        let nameLabel3 = UILabel(frame: CGRect(x: scrollView.frame.width * 2, y: labelYPosition, width: scrollView.frame.width, height: labelHeight))
        let dateAndRatingLabel3 = UILabel(frame: CGRect(x: scrollView.frame.width * 2, y: labelYPosition + labelHeight, width: scrollView.frame.width, height: labelHeight))
        
        nameLabel1.text = topGameList[0].name
        dateAndRatingLabel1.text = "Released: \(topGameList[0].released), Rating: \(topGameList[0].rating)"
        
        nameLabel2.text = topGameList[1].name
        dateAndRatingLabel2.text = "Released: \(topGameList[1].released), Rating: \(topGameList[1].rating)"
        
        nameLabel3.text = topGameList[2].name
        dateAndRatingLabel3.text = "Released: \(topGameList[2].released), Rating: \(topGameList[2].rating)"
        
        nameLabel1.textAlignment = .center
        dateAndRatingLabel1.textAlignment = .center
        
        nameLabel2.textAlignment = .center
        dateAndRatingLabel2.textAlignment = .center
        
        nameLabel3.textAlignment = .center
        dateAndRatingLabel3.textAlignment = .center
        
        nameLabel1.backgroundColor = .white
        dateAndRatingLabel1.backgroundColor = .white
        
        nameLabel2.backgroundColor = .white
        dateAndRatingLabel2.backgroundColor = .white
        
        nameLabel3.backgroundColor = .white
        dateAndRatingLabel3.backgroundColor = .white
        
        scrollView.addSubview(nameLabel1)
        scrollView.addSubview(dateAndRatingLabel1)
        
        scrollView.addSubview(nameLabel2)
        scrollView.addSubview(dateAndRatingLabel2)
        
        scrollView.addSubview(nameLabel3)
        scrollView.addSubview(dateAndRatingLabel3)
        
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
        remainingGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCell
        
        cell.configure(model: remainingGames[indexPath.row])
        
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

extension GameViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //filterContextForSearchtext(searchBar.text!)
    }
}