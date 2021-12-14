//
//  SongCell.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Novikov on 09.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

final class SongCell: UITableViewCell {
    
    static public let reuseIdentifier = "musicCellID"
    
    private(set) lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    private(set) lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    func configure(with cellModel: SongCellModel) {
        self.songNameLabel.text = cellModel.trackName
        self.artistNameLabel.text = cellModel.artistName
    }
    
    
    override func prepareForReuse() {
        self.artworkImageView.image = nil
        self.songNameLabel.text = nil
        self.artistNameLabel.text = nil
    }
    
    private func configureUI() {
        addArtworkImageView()
        addSongNameLabel()
        addArtistNameLabel()
    }
    
    private func addArtworkImageView() {
        self.contentView.addSubview(artworkImageView)
        
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.0),
            artworkImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7.0),
            artworkImageView.widthAnchor.constraint(equalToConstant: 55),
            artworkImageView.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    private func addSongNameLabel() {
        self.contentView.addSubview(songNameLabel)
        
        NSLayoutConstraint.activate([
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            songNameLabel.leftAnchor.constraint(equalTo: artworkImageView.rightAnchor, constant: 10.0),
            songNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7.0)
        ])
        
    }
    
    private func addArtistNameLabel() {
        self.contentView.addSubview(artistNameLabel)
        
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8.0),
            artistNameLabel.leftAnchor.constraint(equalTo: artworkImageView.rightAnchor, constant: 10.0),
            artistNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7.0)
        ])
    }
}

