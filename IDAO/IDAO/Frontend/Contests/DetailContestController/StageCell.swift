//
//  StageCell.swift
//  IDAO
//
//  Created by Ivan Lebedev on 10.05.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class StageCell: UICollectionViewCell {
    
    @IBOutlet weak var stageNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    
    func configureView(stage: Contest.Stage?) {
        self.stageNameLabel.text = stage?.name ?? "No name"
        self.startDateLabel.text = "Start: \(IdaoManager.shared.getDateFormatter().string(from: stage?.startDate ?? Date()))"
        self.endDateLabel.text = "End: \(IdaoManager.shared.getDateFormatter().string(from: stage?.endDate ?? Date()))"
        
        self.layer.cornerRadius = 8
    }
}
