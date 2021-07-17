//
//  TimeContainerViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/11.
//

import UIKit

final class TimeContainerViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var alarmContainer: UIView!
    @IBOutlet private weak var stopwatchContainer: UIView!
    @IBOutlet private weak var timerContainer: UIView!
    
    private var containers = [UIView]()
    var timeType: TimeType = .alarm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = timeType.title
        segmentedControl.selectedSegmentIndex = timeType.rawValue
        
        containers.append(alarmContainer)
        containers.append(stopwatchContainer)
        containers.append(timerContainer)
        containerView.bringSubviewToFront(containers[timeType.rawValue])
        
    }
    
    static func instantiate(timeType: TimeType) -> TimeContainerViewController {
        let timeContainerVC = UIStoryboard.timeContainer.instantiateViewController(
            withIdentifier: String(describing: self)
        ) as! TimeContainerViewController
        timeContainerVC.modalPresentationStyle = .fullScreen
        timeContainerVC.timeType = timeType
        return timeContainerVC
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction private func segmentedControlDidTapped(_ sender: UISegmentedControl) {
        let currentContainerView = containers[sender.selectedSegmentIndex]
        containerView.bringSubviewToFront(currentContainerView)
        let timeType = TimeType(rawValue: sender.selectedSegmentIndex)!
        self.navigationItem.title = timeType.title
    }
    
}

private extension UIStoryboard {
    static var timeContainer: UIStoryboard {
        return UIStoryboard(name: "TimeContainer", bundle: nil)
    }
}
