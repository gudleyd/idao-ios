//
//  TeamTableViewCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 01.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


class TeamTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.teamMembers?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TeamMemberCell")
        
        cell.backgroundColor = .clear
        cell.accessoryView = nil
    
        if let member = self.team?.teamMembers?[indexPath.row] {
            cell.textLabel?.text = member.name
            cell.detailTextLabel?.text = "@\(member.username)"
            cell.detailTextLabel?.textColor = .systemGray
            
            if member.isLeader() {
                let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
                label.text = "Leader"
                label.textColor = .systemGreen
                cell.accessoryView = label
            }
            
            if member.isInvited() {
                let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
                label.text = "Invited"
                label.textColor = .systemBlue
                cell.accessoryView = label
            }
        }

        return cell
    }
    
    
    var team: Team?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    func setTeam(team: Team) {
        self.team = team
        self.teamNameLabel.text = team.name
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableHeight.constant = self.tableView.contentSize.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 8
        self.selectionStyle = .none
        
        self.contentView.autoresizingMask = [.flexibleHeight]
        
        self.mainView.layer.shadowOffset = CGSize(width: 5, height: 3)
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowRadius = 3
        self.mainView.layer.shadowOpacity = 0.1
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.isUserInteractionEnabled = false
        
        self.tableView.estimatedRowHeight = 57
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
