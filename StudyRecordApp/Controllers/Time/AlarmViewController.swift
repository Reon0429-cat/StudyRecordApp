//
//  AlarmViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

final class AlarmViewController: MyTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instantiate() -> AlarmViewController {
        let alarmVC = UIStoryboard.alarm.instantiateViewController(
            identifier: String(describing: self)
        ) as! AlarmViewController
        alarmVC.modalPresentationStyle = .fullScreen
        return alarmVC
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

private extension UIStoryboard {
    static var alarm: UIStoryboard {
        return UIStoryboard(name: "Alarm", bundle: nil)
    }
}
