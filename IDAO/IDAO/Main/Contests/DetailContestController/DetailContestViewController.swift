//
//  DetailContestViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import MarkdownView

class DetailContestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bodyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var takePartButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    
     private let bodyMd = MarkdownView()
    
    var contest: Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyViewHeight.isActive = false

        self.bodyView.addSubview(self.bodyMd)
        self.bodyMd.backgroundColor = .clear
        self.bodyMd.translatesAutoresizingMaskIntoConstraints = false
        self.bodyMd.topAnchor.constraint(equalTo: self.bodyView.topAnchor).isActive = true
        self.bodyMd.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor).isActive = true
        self.bodyMd.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor).isActive = true
        self.bodyMd.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor).isActive = true
        
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
        
        self.bodyMd.isScrollEnabled = false
        
        self.contest?.stages?.sort(by: {c1, c2 in return c1.startDate < c2.startDate})
        if let minMembers = self.contest?.settings?.minTeamSize,
            let maxMembers = self.contest?.settings?.maxTeamSize {
            self.infoLabel1.text = "\(minMembers)-\(maxMembers) members in team"
        }
        if let regStart = self.contest?.startDate,
            let regEnd = self.contest?.endDate {
            self.infoLabel2.text = "Registration from \(IdaoManager.shared.getDateFormatter().string(from: regStart)) to \(IdaoManager.shared.getDateFormatter().string(from: regEnd))"
        }
        self.contestNameLabel.text = self.contest?.name
        self.bodyMd.load(markdown: "<style>body {background-color: #f2f2f7;}</style><font color=\"#000000\">\n" + (self.contest?.description ?? ""))
        
        let now = Date()
        if Calendar.current.compare(now, to: contest?.startDate ?? Date(), toGranularity: .day) == .orderedDescending {
            self.takePartButton.setTitle("Registration is closed", for: .disabled)
            self.takePartButton.setTitleColor(.systemRed, for: .disabled)
            self.takePartButton.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contest?.stages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "stageCell", for: indexPath) as! StageCell
        cell.configureView(stage: contest?.stages?[indexPath.row])
        return cell
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePartButtonTapped(_ sender: Any) {
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
