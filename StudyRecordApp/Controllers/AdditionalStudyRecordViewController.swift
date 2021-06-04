//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class AdditionalStudyRecordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instantiate() -> UIViewController {
        let storyboard = UIStoryboard.additionalStudyRecord
        let additionalStudyRecordVC = storyboard.instantiateViewController(
            identifier: AdditionalStudyRecordViewController.identifier
        ) as! AdditionalStudyRecordViewController
        additionalStudyRecordVC.modalPresentationStyle = .fullScreen
        return additionalStudyRecordVC
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 保存処理
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo アラート
        dismiss(animated: true, completion: nil)
    }
    
}

private extension UIStoryboard {
    static var additionalStudyRecord: UIStoryboard {
        return UIStoryboard(name: "AdditionalStudyRecord", bundle: nil)
    }
}

private extension AdditionalStudyRecordViewController {
    static var identifier: String { String(describing: self) }
}
