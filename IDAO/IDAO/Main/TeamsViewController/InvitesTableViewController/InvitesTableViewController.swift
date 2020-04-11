//
//  InvitesTableViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit


class InvitesTableViewController: UITableViewController {
    
    var invites: [Int] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.invites.subscribe(InvitesStorage.StorageObserver(delegate: self))
        IdaoStorage.invites.get { [weak self] invites in
            DispatchQueue.main.async {
                self?.invites = invites
                self?.tableView.reloadData()
            }
        }
        
        self.title = "Invites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.closeView))
    }
    
    @objc
    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.invites.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInviteCell", for: indexPath)
        IdaoStorage.teams.get(byId: self.invites[indexPath.row], withMembers: true) { team in
            DispatchQueue.main.async {
                cell.textLabel?.text = team.name
                let leader = team.teamMembers?.first { member in return member.isLeader()}
                cell.detailTextLabel?.text = "leader: \(leader?.username ?? "Unknown")"
                if #available(iOS 13.0, *) {
                    cell.detailTextLabel?.textColor = .systemGray2
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {


        let acceptAction = UITableViewRowAction(style: .default, title: "Accept", handler: { (action, indexPath) in
            IdaoManager.shared.acceptInvite(teamId: self.invites[indexPath.row]) {
                IdaoStorage.invites.update(completionHandler: {})
            }
        })
        acceptAction.backgroundColor = .systemGreen

        let declineAction = UITableViewRowAction(style: .default, title: "Decline", handler: { (action, indexPath) in
            IdaoManager.shared.declineInvite(teamId: self.invites[indexPath.row]) {
                IdaoStorage.invites.update(completionHandler: {})
            }
        })
        declineAction.backgroundColor = .systemRed

        return [acceptAction, declineAction]
    }

}


extension InvitesTableViewController: StorageObserverDelegate {
    func update(_ sender: Any?, _ data: Any?) {
        DispatchQueue.main.async { [weak self] in
            guard let invites = data as? [Int] else { return }
            self?.invites = invites
            self?.tableView.reloadData()
        }
    }
    
    
}
