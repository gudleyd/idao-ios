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
    
    weak var automaticHeightTV: AutomaticHeightCellDelegate?
    
    private let bodyMd = MarkdownView()
    
    func setNews(news: News, completionHandler: @escaping () -> ()) {
        self.bodyMd.onRendered = { [weak self] height in
            DispatchQueue.main.async {
                print(height)
                self?.bodyView.heightAnchor.constraint(equalToConstant: height).isActive = true
                self?.automaticHeightTV?.contentDidChange()
                completionHandler()
            }
        }
        newsTitleLabel.text = news.header
        self.bodyMd.load(markdown: news.body)
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
