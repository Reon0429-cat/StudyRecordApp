//
//  CurrentTimeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

final class CurrentTimeViewController: MyTabBarController {
    
    @IBOutlet private weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 40, weight: .regular)
        currentTimeLabel.text = TimeManager().current()
        scheduledTimer()
        
    }
    
    private func scheduledTimer() {
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateTimer),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func updateTimer() {
        currentTimeLabel.text = TimeManager().current()
    }
    
}
