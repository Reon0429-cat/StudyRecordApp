//
//  StopwatchViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

// MARK: - ToDo ストップウォッチの限界時間を長くする
// MARK: - ToDo バックグラウンドでも処理が行われるようにする

private enum TimerState {
    case played
    case paused
    mutating func toggle() {
        switch self {
            case .played: self = .paused
            case .paused: self = .played
        }
    }
}

final class StopwatchViewController: UIViewController {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var controlTimeButton: UIButton!
    @IBOutlet private weak var resetTimeButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    
    private var timer: Timer?
    private var state: TimerState = .paused
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
                controlTimeButton.isHidden = true
                isOverTime = true
            }
            timeLabel.text = String(format: "%02d:%02d.%02d",
                                    minutes, second, millisecond)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 40, weight: .regular)
        controlTimeButton.layer.cornerRadius = controlTimeButton.frame.height / 2
        resetTimeButton.layer.cornerRadius = resetTimeButton.frame.height / 2
        
    }
    
    @IBAction private func controlTimeButtonDidTapped(_ sender: Any) {
        switch state {
            case .played:
                timer?.invalidate()
            case .paused:
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
        state = .paused
        if isOverTime {
            controlTimeButton.isHidden = false
            isOverTime = false
        }
        updateUI()
    }
    
    private func updateUI() {
        controlTimeButton.setImage({
            switch state {
                case .played:
                    return UIImage(systemName: "pause.fill")!
                case .paused:
                    return UIImage(systemName: "play.fill")!
            }
        }())
    }
}
