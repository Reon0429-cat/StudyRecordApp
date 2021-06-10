//
//  StopwatchViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

private enum TimerState {
    case started
    case stopped
    mutating func toggle() {
        switch self {
            case .started: self = .stopped
            case .stopped: self = .started
        }
    }
}

final class StopwatchViewController: MyTabBarController {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var controlTimeButton: UIButton!
    
    private var state: TimerState = .stopped
    private var timer: Timer?
    private var millisecond: Int { Int(timerCount * 100) % 100 }
    private var second: Int { Int(timerCount) % 60 }
    private var minutes: Int { Int(timerCount / 60) }
    private var timerCount: CGFloat = 0 {
        didSet {
            timeLabel.text = String(format: "%02d:%02d.%02d",
                                    minutes, second, millisecond)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 40, weight: .regular)
        
    }
    
    @IBAction private func controlTimeButtonDidTapped(_ sender: Any) {
        switch state {
            case .started:
                timer?.invalidate()
                controlTimeButton.setTitle("スタート")
            case .stopped:
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    self.timerCount += 0.01
                }
                controlTimeButton.setTitle("ストップ")
        }
        state.toggle()
    }
    
    @IBAction private func resetButtonDidTapped(_ sender: Any) {
        timerCount = 0
        timer?.invalidate()
        controlTimeButton.setTitle("スタート")
        state = .stopped
    }
    
    @IBAction private func advanceTimeButtonDidTapped(_ sender: Any) {
    }
    
    @IBAction private func backTimeButtonDidTapped(_ sender: Any) {
    }
    
}
