//
//  TweetCollectionViewCell.swift
//  ATTwitterClone
//
//  Created by Alvin Tu on 3/2/21.
//  Copyright © 2021 Alvin Tu. All rights reserved.
//

import UIKit
import Lottie

class TweetCollectionViewCell: UICollectionViewCell {
    static let identifier = "TweetCollectionViewCell"
    //Labels
    private let tweetLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private var animationView: AnimationView  = {
        let animation = AnimationView(name:"bird")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        return animation
    }()

    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true
        addSubViews()
    }
    
    private func addSubViews() {
        contentView.addSubview(tweetLabel)
        tweetLabel.sizeToFit()
        contentView.addSubview(animationView)
        animationView.play()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.width/10
        

        let width = contentView.frame.size.width
        let height = contentView.frame.size.height
        tweetLabel.frame = CGRect(x: 20, y: 20, width:width - 20 , height: height)
        animationView.frame = CGRect(x: 0 , y: 0, width:size , height: size)
        animationView.animationSpeed = 2.0
        

    }

    public func configure(with tweet: Tweet){
        tweetLabel.text = tweet.text
        contentView.backgroundColor = UIColor(red: 0.50, green: 0.80, blue: 1.0, alpha: 1.0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
