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
        scheduleTimer()
        
    }
    
    @IBAction private func alarmButtonDidTapped(_ sender: Any) {
        let alarmVC = AlarmViewController.instantiate()
        present(alarmVC, animated: true, completion: nil)
    }
    
    @IBAction private func stopwatchButtonDidTapped(_ sender: Any) {
        let stopwatchVC = StopwatchViewController.instantiate()
        present(stopwatchVC, animated: true, completion: nil)
    }
    
    @IBAction private func timerButtonDidTapped(_ sender: Any) {
        let timerVC = TimerViewController.instantiate()
        present(timerVC, animated: true, completion: nil)
    }
    
    private func scheduleTimer() {
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
