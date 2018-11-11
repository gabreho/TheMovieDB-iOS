//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {
    
    enum MovieListType {
        case nowPlaying, topRated
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var movieListType = MovieListType.nowPlaying
   
    var movies: [Movie] {
        get {
            if movieListType == .topRated {
                return self.topRatedMovies
            } else {
                return self.nowPlayingMovies
            }
        }
        set {
            if movieListType == .topRated {
                self.topRatedMovies = newValue
            } else {
                self.nowPlayingMovies = newValue
            }
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.movies.count
        }
    }
    
    var topRatedMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // TODO load from db
        
        
        if movies.count == 0 {
        }
        
        refresh()
    }
    
    func refresh() {
        
        let moviesRequest = movieListType == .nowPlaying ? MoviesAPI.Movies.nowPlaying() : MoviesAPI.Movies.topRated()
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        moviesRequest.request { [weak self] (response) in
            hud.hide(animated: true)
            if let response = response {
                
                // for "Now playing", ordered by release date
                // "Playing now" ordered by votes
                
                self?.movies = response.results.sorted(by: { (m1, m2) -> Bool in
                    if self?.movieListType == .nowPlaying {
                        return m1.releaseDate > m2.releaseDate
                    }
                    return m1.voteAverage > m2.voteAverage
                })
            } else {
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        movieListType = segmentedControl.selectedSegmentIndex == 0 ? .nowPlaying : .topRated
        self.collectionView.reloadData()
        self.pageControl.currentPage = 0
        
        if self.movies.count == 0 {
            refresh()
        } else {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                             at: .centeredHorizontally,
                                             animated: false)
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        refresh()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewControllerSize = self.collectionView.bounds.size
        return viewControllerSize
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView.indexPathForItem(at: visiblePoint)
        self.pageControl.currentPage = indexPath?.row ?? 0
    }
    
    // we could save the open status of each cell, but for now we reset the status each time the cell appears
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? MovieCell {
            cell.detailsOpen = false
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                      for: indexPath)
        if let cell = cell as? MovieCell {
            cell.setup(with: movies[indexPath.row])
        }
        return cell
    }
}
