//
//  TeamEditControllerViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 05.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class DetailTeamController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamStatusLabel: UILabel!
    
    var team: Team?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addMemberButton.layer.cornerRadius = 8
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        nameLabel.text = team?.name
        if let status = team?.status {
            if status == "LOCKED" {
                teamStatusLabel.isHidden = false
                teamStatusLabel.text = "Team locked"
                teamStatusLabel.textColor = .systemRed
                addMemberButton.isEnabled = false
                addMemberButton.backgroundColor = .systemGray4
            } else {
                teamStatusLabel.isHidden = true
                addMemberButton.isEnabled = true
                addMemberButton.backgroundColor = .systemBlue
            }
        }
    }
    
    func setTeam(teamId: Int) {
        IdaoStorage.teams.get(teamId: teamId) { team in
            self.team = team
        }
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.team?.teamMembers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(self.team?.teamMembers?[indexPath.row].isLeader() ?? true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let memberToRemove = self.team?.teamMembers?[indexPath.row], let teamId = self.team?.id {
                self.present(AlertViewsFactory.removingMember(), animated: true)
                IdaoManager.shared.removeMember(teamId: teamId, userId: memberToRemove.userId) { [weak self] in
                    DispatchQueue.main.async {
                        self?.team?.teamMembers?.remove(at: indexPath.row)
                        self?.presentedViewController?.dismiss(animated: true, completion: nil)
                        self?.tableView.beginUpdates()
                        self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self?.tableView.endUpdates()
                    }
                }
            }
        }
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

}
