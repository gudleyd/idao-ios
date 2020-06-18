//
//  TestStorages.swift
//  IDAO
//
//  Created by Ivan Lebedev on 17.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class TestNewsStorage: INewsStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [News(id: 1,
                           header: "Simple Header",
                           body: "Simple body",
                           publicationDate: Date(),
                           authorId: 2020)]
        for i in 0..<20 {
            self.items.append(contentsOf: [News(id: 2,
                header: "News \(2 * i)",
                body: " [++HSE Faculty of Computer Science++](https://cs.hse.ru/en/) and Yandex launch registration for the 3rd International Data Analysis Olympiad ([++IDAO 2020++](https://idao.world/)). The platinum partner of IDAO 2020 is Qiwi. \n\nThe Olympiad includes two stages:\n\n**Online Stage:**\n\n- Traditional machine learning competition on Yandex.Contest platform. You will need to make new predictions and upload them to the automatic verification system.\n- Track 2: Come up with a solution for the same problem, keeping within a rigid framework of time and memory used.\n\n**Offline Stage (Final):**\n\n- The top 30 teams according to the Online Stage results will be invited to the on-site final, which will be held on April 2-5 in Yandex office, Moscow .\n- In the final 36 hours of the competition, participants will try not just to train the model, but to create a full-fledged prototype, which will be tested both in terms of accuracy and performance. \n\nAs part of IDAO Final, performances and master classes of world experts in machine learning and data analysis are also planned.\n\nIn 2019, 2187 participants from 78 countries took part in IDAO, and 79 participants from 7 countries met in the final in Moscow. \n\nWinners and prize-winners of IDAO 2020 will receive valuable prizes and gifts, as well as an advantage in entering Yandex School of Data Analysis and master\'s programmes at the HSE Faculty of Computer Science.\n",
                publicationDate: Date(),
                authorId: 2020),
            News(id: 1,
            header: "News \(2 * i + 1)",
            body: " [++HSE Faculty of Computer Science++](https://cs.hse.ru/en/) and Yandex launch registration for the 3rd International Data Analysis Olympiad ([++IDAO 2020++](https://idao.world/)). The platinum partner of IDAO 2020 is Qiwi. \n\nThe Olympiad includes two stages:\n\n**Online Stage:**\n\n- Traditional machine learning competition on Yandex.Contest platform. You will need to make new predictions and upload them to the automatic verification system.\n- Track 2: Come up with a solution for the same problem, keeping within a rigid framework of time and memory used.\n\n**Offline Stage (Final):**\n\n- The top 30 teams according to the Online Stage results will be invited to the on-site final, which will be held on April 2-5 in Yandex office, Moscow .\n- In the final 36 hours of the competition, participants will try not just to train the model, but to create a full-fledged prototype, which will be tested both in terms of accuracy and performance. \n\nAs part of IDAO Final, performances and master classes of world experts in machine learning and data analysis are also planned.\n\nIn 2019, 2187 participants from 78 countries took part in IDAO, and 79 participants from 7 countries met in the final in Moscow. \n\nWinners and prize-winners of IDAO 2020 will receive valuable prizes and gifts, as well as an advantage in entering Yandex School of Data Analysis and master\'s programmes at the HSE Faculty of Computer Science.\n",
            publicationDate: Date(),
            authorId: 2020)])
            if i % 5 == 0 {
                self.items.append(News(id: 1,
                header: "Simple Header",
                body: "Simple body",
                publicationDate: Date(),
                authorId: 2020))
            }
            if i % 10 == 0 {
                self.items.append(contentsOf: [News(id: 1,
                header: "Simple Header",
                body: "Simple body",
                publicationDate: Date(),
                authorId: 2020), News(id: 1,
                header: "Simple Header",
                body: "Simple body",
                publicationDate: Date(),
                authorId: 2020)])
            }
        }
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
}


class TestTeamsStorage: ITeamsStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [1, 2, 3, 4, 5]
    }
    
    final override func get(teamId: Int, completionHandler: @escaping (Team) -> ()) {
        switch teamId {
        case 1: completionHandler(Team(id: teamId, name: "Team name with me as LEADER", status: "LOCKED", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 0, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 4, role: "OTHER", status: "INVITED")]))
        case 2: completionHandler(Team(id: teamId, name: "Team WITH VERY VERY LONG NAME", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 0, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 8, role: "OTHER", status: "INVITED")]))
        case 3: completionHandler(Team(id: teamId, name: "Team name with 3 members", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 1, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 2, role: "OTHER", status: "INVITED"), Team.TeamMember(id: 3, teamId: teamId, userId: 3, role: "OTHER", status: "ACCEPTED")]))
        case 4: completionHandler(Team(id: teamId, name: "Team name but LOCKED", status: "LOCKED", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 4, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 5, role: "OTHER", status: "ACCEPTED"), Team.TeamMember(id: 3, teamId: teamId, userId: 6, role: "OTHER", status: "ACCEPTED")]))
        case 5: completionHandler(Team(id: teamId, name: "long long team name but locked long long longlong long", status: "LOCKED", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 2, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 4, role: "OTHER", status: "ACCEPTED")]))
        case 6: completionHandler(Team(id: teamId, name: "FBI", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 7, role: "LEADER", status: "ACCEPTED")]))
        case 7: completionHandler(Team(id: teamId, name: "Winners", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 4, role: "LEADER", status: "ACCEPTED")]))
        case 8: completionHandler(Team(id: teamId, name: "Antihype", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 2, role: "LEADER", status: "ACCEPTED")]))
        default: completionHandler(Team(id: teamId, name: "Team name", status: "OPEN", registrationDate: Date(), teamMembers: [Team.TeamMember(id: 1, teamId: teamId, userId: 0, role: "LEADER", status: "ACCEPTED"), Team.TeamMember(id: 2, teamId: teamId, userId: 9, role: "OTHER", status: "INVITED")]))
        }
    }
    
    final override func getAllTeams(filter: @escaping (Team) -> (Bool), completionHandler: @escaping ([Team]) -> ()) {
        var teams = [Team]()
        for teamId in self.items {
            self.get(teamId: teamId) { team in
                if filter(team) {
                    teams.append(team)
                }
            }
        }
        completionHandler(teams)
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
}


class TestInvitesStorage: IInvitesStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [6, 7, 8]
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
}


class TestContestsStorage: IContestsStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [Contest(id: 1,
                              name: "Simple Contest",
                              description: "Simple description",
                              startDate: Date(timeIntervalSinceNow: -100000000),
                              endDate: Date(timeIntervalSinceNow: 10000000),
                              status: "OPENED",
                              settings: nil,
                              stages: [Contest.Stage(id: 1, contestId: 1, name: "Simple Stage 1", startDate: Date(timeIntervalSinceNow: -20000000), endDate: Date(timeIntervalSinceNow: -180000000), platformLink: nil), Contest.Stage(id: 2, contestId: 1, name: "Simple Stage 2", startDate: Date(timeIntervalSinceNow: -150000000), endDate: Date(timeIntervalSinceNow: -10000000), platformLink: nil)]),
                    Contest(id: 3,
                    name: "Simple Contest",
                    description: "Simple description",
                    startDate: Date(timeIntervalSinceNow: 100000),
                    endDate: Date(timeIntervalSinceNow: 1000000000),
                    status: "OPENED",
                    settings: nil,
                    stages: [Contest.Stage(id: 1, contestId: 3, name: "Simple Stage 1", startDate: Date(timeIntervalSinceNow: -20000000), endDate: Date(timeIntervalSinceNow: -180000000), platformLink: nil), Contest.Stage(id: 2, contestId: 3, name: "Simple Stage 2", startDate: Date(timeIntervalSinceNow: -150000000), endDate: Date(timeIntervalSinceNow: -10000000), platformLink: nil)]),
                    Contest(id: 2,
                    name: "Simple Contest",
                    description: "Simple description",
                    startDate: Date(timeIntervalSinceNow: -100000000),
                    endDate: Date(timeIntervalSinceNow: -1000),
                    status: "CLOSED",
                    settings: nil,
                    stages: [Contest.Stage(id: 1, contestId: 2, name: "Simple Stage 1", startDate: Date(timeIntervalSinceNow: -20000000), endDate: Date(timeIntervalSinceNow: -180000000), platformLink: nil), Contest.Stage(id: 2, contestId: 2, name: "Simple Stage 2", startDate: Date(timeIntervalSinceNow: -150000000), endDate: Date(timeIntervalSinceNow: -10000000), platformLink: nil)]),
                    Contest(id: 4,
                    name: "Contest where you should teach computer things you have never listen about",
                    description: "This year the online task is coming from astronomy. It is focused on building a model that would predict the position of space objects using simulation data. The task was given by Russian Astronomical Science Center (ASC) and adopted for the Olympiad by the Laboratory of Methods for Big Data Analysis (LAMBDA, HSE University).\n\n​\n\nAll teams MUST join the competition on this platform until January 21, so within this time new teams are able to join. If a team has already joined the contest, it can not change team members.  \n\n​\n\nAfter your team joins the competition here, it will receive Yandex.Contest login and password via email. The Online Task itself will be available here  - [https://official.contest.yandex.ru/contest/16669/enter/](https://official.contest.yandex.ru/contest/16669/enter/) . Please notice that the Task will be open at 12-00 (UTC +3) on January 15, 2020.\n",
                    startDate: Date(timeIntervalSinceNow: -100000000),
                    endDate: Date(timeIntervalSinceNow: -1000),
                    status: "CLOSED",
                    settings: nil,
                    stages: [Contest.Stage(id: 1, contestId: 2, name: "Simple Stage 1", startDate: Date(timeIntervalSinceNow: -20000000), endDate: Date(timeIntervalSinceNow: -180000000), platformLink: nil), Contest.Stage(id: 2, contestId: 2, name: "Simple Stage 2", startDate: Date(timeIntervalSinceNow: -150000000), endDate: Date(timeIntervalSinceNow: -10000000), platformLink: nil)])]
        for i in 0..<20 {
            self.items.append(contentsOf: [Contest(id: 4,
            name: "Contest \(i)",
            description: "This year the online task is coming from astronomy. It is focused on building a model that would predict the position of space objects using simulation data. The task was given by Russian Astronomical Science Center (ASC) and adopted for the Olympiad by the Laboratory of Methods for Big Data Analysis (LAMBDA, HSE University).\n\n​\n\nAll teams MUST join the competition on this platform until January 21, so within this time new teams are able to join. If a team has already joined the contest, it can not change team members.  \n\n​\n\nAfter your team joins the competition here, it will receive Yandex.Contest login and password via email. The Online Task itself will be available here  - [https://official.contest.yandex.ru/contest/16669/enter/](https://official.contest.yandex.ru/contest/16669/enter/) . Please notice that the Task will be open at 12-00 (UTC +3) on January 15, 2020.\n",
            startDate: Date(timeIntervalSinceNow: -100000000),
            endDate: Date(timeIntervalSinceNow: -1000),
            status: "CLOSED",
            settings: nil,
            stages: [Contest.Stage(id: 1, contestId: 2, name: "Simple Stage 1", startDate: Date(timeIntervalSinceNow: -20000000), endDate: Date(timeIntervalSinceNow: -180000000), platformLink: nil), Contest.Stage(id: 2, contestId: 2, name: "Simple Stage 2", startDate: Date(timeIntervalSinceNow: -150000000), endDate: Date(timeIntervalSinceNow: -10000000), platformLink: nil)])])
        }
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
}


class TestAppUserStorage: IAppUserStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [User(account: User.Account(id: 0, name: "Ivan Lebedev", username: "gudleyd", roles: nil),
                           personalData: User.PersonalData(userId: 0, email: "test@test.test", birthday: Date(), phoneNumber: "+79999999999", gender: "male", countryOfResidence: "Russian Federation", university: "HSE", studyProgram: "AMI", levelOfStudy: "Bachelor", company: "Millenium Falcon", registrationDate: Date()))]
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
}

class TestUserAccountsStorage: IUserAccountsStorage {
    
    init() {
        super.init(makeUpdate: false)
        
        self.items = [1, 2, 3, 4, 5, 6]
    }
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.notify()
        completionHandler()
    }
    
    final override func get(userId: Int, completionHandler: ((User.Account) -> ())) {
        switch userId {
        case 0: completionHandler(User.Account(id: 0, name: "Ivan Lebedev", username: "gudleyd", roles: nil))
        case 1: completionHandler(User.Account(id: userId, name: "Luke Skywalker", username: "newhope", roles: nil))
        case 2: completionHandler(User.Account(id: userId, name: "Rey Skywalker", username: "hopemurderer", roles: nil))
        case 3: completionHandler(User.Account(id: userId, name: "Anonymous", username: "mr.robot", roles: nil))
        case 4: completionHandler(User.Account(id: userId, name: "Douglas Adams", username: "writer", roles: nil))
        case 5: completionHandler(User.Account(id: userId, name: "Pied Piper", username: "pp", roles: nil))
        case 6: completionHandler(User.Account(id: userId, name: "Test Userov", username: "testtest", roles: nil))
        default: completionHandler(User.Account(id: userId, name: "Ivan Ivanov", username: "ii", roles: nil))
        }
    }
}
