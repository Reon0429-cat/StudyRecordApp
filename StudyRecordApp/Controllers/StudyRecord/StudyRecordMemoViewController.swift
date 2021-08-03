//
//  StudyRecordMemoViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/03.
//

import UIKit

final class StudyRecordMemoViewController: UIViewController {
    
    @IBOutlet private weak var baseView: UIView! {
        didSet { baseView.layer.cornerRadius = 10 }
    }
    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
    }
    
    static func instantiate() -> StudyRecordMemoViewController {
        let storyboard = UIStoryboard(name: "StudyRecordMemo", bundle: nil)
        let studyRecordMemoVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! StudyRecordMemoViewController
        studyRecordMemoVC.modalPresentationStyle = .overCurrentContext
        studyRecordMemoVC.modalTransitionStyle = .crossDissolve
        return studyRecordMemoVC
    }
    
    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "保存せずにメモを閉じます", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "保存する", style: .default, handler: { _ in
            // MARK: - ToDo 保存処理
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 保存処理
        dismiss(animated: true, completion: nil)
    }
    
}

extension StudyRecordMemoViewController: UITextViewDelegate {
    
}


