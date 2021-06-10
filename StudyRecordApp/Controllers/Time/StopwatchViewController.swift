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
    @IBOutlet private weak var stackView: UIStackView!
    
    private var timer: Timer?
    private var state: TimerState = .stopped
    private var minutes: Int { Int(timerCount / 60) }
    private var second: Int { Int(timerCount) % 60 }
    private var millisecond: Int { Int(timerCount * 100) % 100 }
    private var isOverTime = false
    private var timerCount: CGFloat = 0 {
        didSet {
            if timerCount < 0 {
                timerCount = 0
            }
            if timerCount > 5999 {
                timer?.invalidate()
                hideControlTimeButton(true)
                isOverTime = true
            }
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
            case .stopped:
                timer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                             repeats: true) { [weak self] _ in
                    self?.timerCount += 0.01
                }
        }
        state.toggle()
        updateUI()
    }
    
    @IBAction private func resetButtonDidTapped(_ sender: Any) {
        timerCount = 0
        timer?.invalidate()
        state = .stopped
        if isOverTime {
            hideControlTimeButton(false)
            isOverTime = false
        }
        updateUI()
    }
    
    private func hideControlTimeButton(_ isHidden: Bool) {
        stackView.arrangedSubviews[0].isHidden = isHidden
    }
    
    private func updateUI() {
        controlTimeButton.setTitle(
            {
                switch state {
                    case .started: return "ストップ"
                    case .stopped: return "スタート"
                }
            }()
        )
    }
    
}


