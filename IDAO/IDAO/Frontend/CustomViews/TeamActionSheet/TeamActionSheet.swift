//
//  TeamActionSheet.swift
//  IDAO
//
//  Created by Ivan Lebedev on 10.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import Foundation


func TeamActionSheet(teamId: Int, parentView: UIViewController) -> UIAlertController {
    var team: Team!
    IdaoStorage.teams.get(teamId: teamId) { teamObj in
        team = teamObj
    }
    
    let alert = UIAlertController(title: team.name, message: nil, preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(title: "Invite Member", style: .default , handler:{ [weak parentView] (_) in
        let inviteNewMember = AlertViewsFactory.inviteMember { alertAction, alertController in
            parentView?.present(AlertViewsFactory.invitingUser(), animated: true)
            let username = alertController.textFields?[0].text ?? ""
            if username == "" {
                DispatchQueue.main.async {
                    parentView?.present(AlertViewsFactory.emptyUsername(), animated: true, completion: nil)
                }
            } else {
                IdaoManager.shared.getUsers(username: username) { [weak parentView] users in
                    if (users.count != 1) {
                        DispatchQueue.main.async {
                            parentView?.present(AlertViewsFactory.userNotFound(), animated: true, completion: nil)
                        }
                        return
                    }
                    
                    IdaoManager.shared.inviteUser(teamId: team.id, userId: users[0].id) { [weak parentView] status in
                        IdaoStorage.teams.update(forceUpdate: true) { }
                        DispatchQueue.main.async {
                            parentView?.presentedViewController?.dismiss(animated: true) { [weak parentView] in
                                if status == .sent {
                                    IdaoStorage.teams.update { }
                                } else if status == .userNotFound {
                                    parentView?.present(AlertViewsFactory.userNotFound(), animated: true, completion: nil)
                                } else {
                                    parentView?.present(AlertViewsFactory.unknownError(), animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
        parentView?.present(inviteNewMember, animated: true, completion: nil)
    }))

    alert.addAction(UIAlertAction(title: (team.amILeader() ? "Delete" : "Leave"), style: .destructive , handler:{ [weak parentView](_) in
        if team.amILeader() {
            DispatchQueue.main.async {
                parentView?.present(AlertViewsFactory.deletingTeam(), animated: true) {
                    IdaoManager.shared.deleteTeam(teamId: team.id) {
                        IdaoStorage.teams.update { }
                        DispatchQueue.main.async {
                            parentView?.presentedViewController?.dismiss(animated: true)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                parentView?.present(AlertViewsFactory.leavingTeam(), animated: true) {
                    IdaoManager.shared.removeMember(teamId: team.id, userId: IdaoManager.shared.myUserId() ?? -1) {
                        IdaoStorage.teams.update { }
                        DispatchQueue.main.async {
                            parentView?.presentedViewController?.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }))

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    return alert
}
