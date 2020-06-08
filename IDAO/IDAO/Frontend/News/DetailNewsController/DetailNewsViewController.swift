//
//  DetailNewsViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 17.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import MarkdownView

class DetailNewsViewController: UIViewController {
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bodyHeight: NSLayoutConstraint!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let bodyMd = MarkdownView()
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bodyHeight.isActive = false
        
        self.bodyView.addSubview(self.bodyMd)
        self.bodyMd.translatesAutoresizingMaskIntoConstraints = false
        self.bodyMd.topAnchor.constraint(equalTo: self.bodyView.topAnchor).isActive = true
        self.bodyMd.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor).isActive = true
        self.bodyMd.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor).isActive = true
        self.bodyMd.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor).isActive = true
        self.bodyMd.isScrollEnabled = false
        
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
        
        IdaoStorage.accounts.get(userId: news?.authorId ?? -1) { author in
            self.newsTitleLabel.text = self.news?.header
            self.bodyMd.load(markdown: "<style>body {background-color: #f2f2f7;}</style><font color=\"#000000\">\n" + (self.news?.body ?? ""))
            self.authorLabel.text = "@\(author.username)"
            self.dateLabel.text = "\(IdaoManager.shared.getDateFormatter().string(from: news?.publicationDate ?? Date()))"
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
