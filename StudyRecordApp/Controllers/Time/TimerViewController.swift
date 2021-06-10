//
//  TimerViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

final class TimerViewController: MyTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instantiate() -> TimerViewController {
        let timerVC = UIStoryboard.timer.instantiateViewController(
            identifier: String(describing: self)
        ) as! TimerViewController
        timerVC.modalPresentationStyle = .fullScreen
        return timerVC
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

private extension UIStoryboard {
    static var timer: UIStoryboard {
        return UIStoryboard(name: "Timer", bundle: nil)
    }
}
