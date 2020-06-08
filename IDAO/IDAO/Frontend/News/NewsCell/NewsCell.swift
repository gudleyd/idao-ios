//
//  NewsCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 07.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import MarkdownView

class NewsCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bodyHeight: NSLayoutConstraint!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    weak var delegate: AutomaticHeightCellDelegate?
    
    private let bodyMd = MarkdownView()
    private let gradient = CAGradientLayer()
    
    func setNews(news: News) {
        self.bodyMd.onRendered = { [weak self] height in
            DispatchQueue.main.async {
    
                if height > 300 {
                    self?.bodyHeight.constant = 260
                } else {
                    self?.bodyHeight.constant = height + 50
                }
                self?.layoutIfNeeded()
                self?.bodyMd.layoutIfNeeded()
                
                if let bounds = self?.detailView.bounds {
                    self?.gradient.frame = bounds
                }
                
                if let view = self?.detailView {
                    self?.detailView.superview?.bringSubviewToFront(view)
                }
                self?.parentView.isHidden = false
                self?.delegate?.contentDidChange()
            }
        }
        
        IdaoStorage.accounts.get(userId: news.authorId) { author in
            self.newsTitleLabel.text = news.header
            self.dateLabel.text = "\(IdaoManager.shared.getDateFormatter().string(from: news.publicationDate))"
            self.authorLabel.text = "@\(author.username)"
            self.bodyMd.load(markdown: news.body)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.parentView.layer.cornerRadius = 8
        self.parentView.layer.shadowOffset = CGSize(width: 5, height: 3)
        self.parentView.layer.shadowColor = UIColor.black.cgColor
        self.parentView.layer.shadowRadius = 3
        self.parentView.layer.shadowOpacity = 0.1
        self.parentView.isHidden = true
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.contentView.autoresizingMask = [.flexibleHeight]
        
        self.gradient.frame = self.detailView.bounds
        var color = UIColor(red: 242, green: 242, blue: 247, alpha: 1)
        if #available(iOS 13.0, *) {
            color = UIColor.systemBackground
        }
        self.gradient.colors = [color.withAlphaComponent(0.1).cgColor, color.withAlphaComponent(0.6).cgColor, color.withAlphaComponent(0.99).cgColor,
            color.withAlphaComponent(1.0).cgColor]
        self.gradient.locations = [0.0, 0.4, 0.5, 1.0]
        self.detailView.layer.insertSublayer(self.gradient, at: 0)
        
        self.bodyView.layer.cornerRadius = 4
        self.bodyView.addSubview(self.bodyMd)
        self.bodyMd.translatesAutoresizingMaskIntoConstraints = false
        self.bodyMd.topAnchor.constraint(equalTo: self.bodyView.topAnchor).isActive = true
        self.bodyMd.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor).isActive = true
        self.bodyMd.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor).isActive = true
        self.bodyMd.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor).isActive = true
        self.bodyMd.isScrollEnabled = false
        self.bodyMd.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
