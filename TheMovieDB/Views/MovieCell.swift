//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var titleMovieView: UIView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var viewMoreView: UIView!
    
    @IBOutlet weak var movieDetailsView: UIView!
    
    @IBOutlet weak var movieDetailsViewHeightConstraint: NSLayoutConstraint!
    
    var detailsOpen: Bool = false {
        didSet {
            toggleView()
        }
    }
    
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        return df
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func viewMoreAction(_ sender: Any) {
        detailsOpen = !detailsOpen
        toggleView()
    }
    
    func toggleView() {
        viewMoreButton.setTitle(detailsOpen ? "View less": "View more", for: .normal)
        
        let height = detailsOpen ?
            self.bounds.height - titleMovieView.bounds.height - viewMoreView.bounds.height :
            50
        
        movieDetailsViewHeightConstraint.constant = height
        movieDetailsView.alpha = detailsOpen ? 1.0 : 0.0
    }
    
    func setup(with movie: Movie) {
        let imgUrl = MoviesAPI.imageUrl(with: movie.posterPath)
        posterImageView.sd_setImage(with: URL(string: imgUrl), completed: nil)
        self.titleMovieLabel.text = movie.title
        self.voteAverageLabel.text = "Vote avg: \(movie.voteAverage)"
        let releaseDate = MovieCell.dateFormatter.string(from: movie.releaseDate)
        self.releaseDateLabel.text = "Release date: \(releaseDate)"
        self.overviewTextView.text = movie.overview
    }
}
