//
//  ContestCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


class ContestCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contestsTitleLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var bodyHeight: NSLayoutConstraint!
    
    weak var delegate: AutomaticHeightCellDelegate?
    var indexPath: IndexPath!
    
    private let bodyMd = MarkdownView()
    private let gradient = CAGradientLayer()
    
    func setContest(contest: Contest) {
        self.bodyMd.onRendered = { [weak self] height in
            DispatchQueue.main.async {
    
                if height > 300 {
                    self?.bodyHeight.constant = 260
                } else {
                    self?.bodyHeight.constant = height + 50
                }
                
                if let bounds = self?.detailView.bounds {
                    self?.gradient.frame = bounds
                }
                
                if let view = self?.detailView {
                    self?.detailView.superview?.bringSubviewToFront(view)
                }
                self?.contestsTitleLabel.sizeToFit()
                // 68 is sum of all vertical insects
                let cellHeight = (self?.contestsTitleLabel.frame.height ?? 0) + (self?.bodyHeight.constant ?? 0) + 68
                self?.parentView.isHidden = false
                self?.delegate?.contentDidChange(height: cellHeight, at: self?.indexPath)
            }
        }
        self.bodyMd.load(markdown: contest.description, enableImage: true)
        
        self.contestsTitleLabel.text = contest.name
        let now = Date()
        if Calendar.current.compare(now, to: contest.startDate, toGranularity: .second) == .orderedAscending {
            self.registrationLabel.text = "Registration will open on \(IdaoManager.shared.getDateFormatter().string(from: contest.startDate))"
            self.registrationLabel.textColor = .systemBlue
        } else if Calendar.current.compare(now, to: contest.endDate, toGranularity: .second) == .orderedAscending {
            self.registrationLabel.text = "Registration is open until \(IdaoManager.shared.getDateFormatter().string(from:contest.endDate))"
            self.registrationLabel.textColor = .systemGreen
        } else {
            self.registrationLabel.text = "Registration is closed"
            self.registrationLabel.textColor = .systemRed
        }
    }
    
    func cancelRendering() {
        self.bodyMd.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.contestsTitleLabel.adjustsFontSizeToFitWidth = true
        self.contestsTitleLabel.minimumScaleFactor = 0.33
        
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
        
        let color = UIColor.white
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
