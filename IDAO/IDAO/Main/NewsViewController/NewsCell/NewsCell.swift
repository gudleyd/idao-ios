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
    
    weak var delegate: AutomaticHeightCellDelegate?
    
    private let bodyMd = MarkdownView()
    
    func setNews(news: News) {
        self.bodyMd.onRendered = { [weak self] height in
            DispatchQueue.main.async {
                self?.bodyHeight.constant = height
                self?.layoutIfNeeded()
                self?.bodyMd.layoutIfNeeded()

                self?.delegate?.contentDidChange()
            }
        }
        
        var isDarkMode: Bool = false
        if #available(iOS 12.0, *) {
            isDarkMode = traitCollection.userInterfaceStyle == .dark
        }
        
        let styleString: String = "<style>body{background-color:\(isDarkMode ? "rgb(0, 0, 0)" : "rgb(255, 255, 255)");color:\(isDarkMode ? "rgb(255, 255, 255)" : "rgb(0, 0, 0)");}</style>\n"
        
        newsTitleLabel.text = news.header
        self.bodyMd.load(markdown: styleString + news.body)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.mainView.layer.cornerRadius = 8
        
        self.contentView.autoresizingMask = [.flexibleHeight]
        
        self.bodyView.layer.cornerRadius = 4
        bodyView.addSubview(bodyMd)
        bodyMd.translatesAutoresizingMaskIntoConstraints = false
        bodyMd.topAnchor.constraint(equalTo: bodyView.topAnchor).isActive = true
        bodyMd.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor).isActive = true
        bodyMd.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor).isActive = true
        bodyMd.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor).isActive = true
        bodyMd.isScrollEnabled = false
        
        self.bodyMd.onTouchLink = { request in
            guard let url = request.url else { return false }
            if url.scheme == "file" {
                return false
            } else if url.scheme == "https" {
                UIApplication.shared.open(url)
                return false
            } else {
                return false
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
