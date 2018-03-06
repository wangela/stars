//
//  DiscoverLandscapeCell.swift
//  Stars
//
//  Created by Angela Yu on 3/6/18.
//  Copyright © 2018 Angela Yu. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class DiscoverLandscapeCell: UITableViewCell {
    
    @IBOutlet var trailerView: YTPlayerView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func loadImage(for view: UIImageView, from imageUrl: URL) {
//        let imageRequest = URLRequest(url: imageUrl)
//
//        view.setImageWith(
//            imageRequest,
//            placeholderImage: nil,
//            success: { (imageRequest, imageResponse, image) -> Void in
//
//                // imageResponse will be nil if the image is cached
//                if imageResponse != nil {
//                    view.alpha = 0.0
//                    view.image = image
//                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                        view.alpha = 1.0
//                    })
//                } else {
//                    view.image = image
//                }
//        },
//            failure: { (imageRequest, imageResponse, error) -> Void in
//                // do something for the failure condition
//        })
//    }
}
