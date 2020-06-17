//
//  TeamTableViewCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 01.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


class TeamTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var team: Team?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    var delegate: AutomaticHeightCellDelegate?
    
    func setTeam(teamId: Int) {
        DispatchQueue.global().async { [weak self] in
            IdaoStorage.teams.get(teamId: teamId) { team in
                DispatchQueue.main.async {
                    self?.team = team
                    self?.teamNameLabel.text = team.name
                    if self?.team?.isLocked() ?? false {
                        self?.mainView.backgroundColor = .systemPink
                    }
                    self?.tableView.reloadData()
                    self?.tableView.layoutIfNeeded()
                    self?.tableHeight.constant = self?.tableView.contentSize.height ?? 0
                    self?.delegate?.contentDidChange()
                }
            }
        }
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
        self.tableView.isUserInteractionEnabled = true
        self.tableView.backgroundColor = .clear
        
        self.tableView.estimatedRowHeight = 57
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.teamMembers?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TeamMemberCell")
        
        cell.backgroundColor = .clear
        cell.accessoryView = nil
    
        if let member = self.team?.teamMembers?[indexPath.row] {
            IdaoStorage.accounts.get(userId: member.userId) { account in
                cell.textLabel?.text = "\(account.name)"
                cell.detailTextLabel?.text = "@\(account.username)"
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
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (!(self.team?.isLocked() ?? true) && (self.team?.amILeader() ?? false) &&
            !(self.team?.teamMembers?[indexPath.row].isLeader() ?? true))
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let memberToRemove = self.team?.teamMembers?[indexPath.row], let teamId = self.team?.id {
                IdaoManager.shared.removeMember(teamId: teamId, userId: memberToRemove.userId) {
                    IdaoStorage.teams.update(forceUpdate: true) { }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
