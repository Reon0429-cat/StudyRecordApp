//
//  CurrentTimeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

enum TimeType: Int {
    case alarm
    case stopwatch
    case timer
    var title: String {
        switch self {
            case .alarm: return "アラーム"
            case .stopwatch: return "ストップウォッチ"
            case .timer: return "タイマー"
        }
    }
}

final class CurrentTimeViewController: UIViewController {
    
    @IBOutlet private weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 40, weight: .regular)
        currentTimeLabel.text = TimeManager().current()
        scheduleTimer()
        
    }
    
    @IBAction private func alarmButtonDidTapped(_ sender: Any) {
        pushTimeContainerVC(.alarm)
    }
    
    @IBAction private func stopwatchButtonDidTapped(_ sender: Any) {
        pushTimeContainerVC(.stopwatch)
    }
    
    @IBAction private func timerButtonDidTapped(_ sender: Any) {
        pushTimeContainerVC(.timer)
    }
    
    private func scheduleTimer() {
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateTimer),
                             userInfo: nil,
                             repeats: true)
    }
    
    private func pushTimeContainerVC(_ timeType: TimeType) {
        let timeContainerVC = TimeContainerViewController.instantiate(timeType: timeType)
        self.navigationController?.pushViewController(timeContainerVC, animated: false)
    }
    
    @objc private func updateTimer() {
        currentTimeLabel.text = TimeManager().current()
    }
    
}
