//
//  TeamTableViewCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 01.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class TeamCellStackViews {

    static func LeaderBadge() -> UIView {
        let mainView = UIView()
        let view = UIView(frame: CGRect(x: 100, y: 1000, width: 60, height: 40))
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 8
        mainView.addSubview(view)
        return mainView
    }

    static func othersCell(count: Int) -> UIView {
        let othersLabel = UILabel()
        othersLabel.text = "and \(count) more"
        othersLabel.textAlignment = .center
        
        return othersLabel
    }
    
    static func personCell(name: String, username: String, isLeader: Bool) -> UIView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.backgroundColor = UIColor.blue
        
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let usernameLabel = UILabel()
        usernameLabel.text = username
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(usernameLabel)
        
        hStackView.addArrangedSubview(vStackView)
        if isLeader {
            hStackView.addArrangedSubview(LeaderBadge())
        }

        return hStackView
    }
}

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var membersStackView: UIStackView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    func setTeam(team: Team) {
        for _ in 0..<self.membersStackView.arrangedSubviews.count {
            self.membersStackView.arrangedSubviews[0].removeFromSuperview()
        }
        self.teamNameLabel.text = team.name
        if let teamMembers = team.teamMembers {
            for i in 0..<min(3, teamMembers.count) {
                self.membersStackView.addArrangedSubview(TeamCellStackViews.personCell(name: teamMembers[i].name, username: teamMembers[i].username, isLeader: teamMembers[i].isLeader()))
            }
            if (teamMembers.count > 3) {
                self.membersStackView.addArrangedSubview(TeamCellStackViews.othersCell(count: teamMembers.count - 3))
            }
            self.membersStackView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 8
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
