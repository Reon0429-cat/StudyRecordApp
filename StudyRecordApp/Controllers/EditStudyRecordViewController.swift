//
//  EditStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class EditStudyRecordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instantiate() -> EditStudyRecordViewController {
        let storyboard = UIStoryboard.editStudyRecordVC
        let editStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! EditStudyRecordViewController
        editStudyRecordVC.modalPresentationStyle = .fullScreen
        return editStudyRecordVC
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
    static var editStudyRecordVC: UIStoryboard {
        return UIStoryboard(name: "EditStudyRecord", bundle: nil)
    }
}
