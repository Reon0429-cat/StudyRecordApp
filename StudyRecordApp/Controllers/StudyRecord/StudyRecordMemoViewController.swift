//
//  StudyRecordMemoViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/03.
//

import UIKit

protocol StudyRecordMemoVCDelegate: AnyObject {
    func savedMemo(memo: String)
}

final class StudyRecordMemoViewController: UIViewController {
    
    @IBOutlet private weak var baseView: UIView! {
        didSet { baseView.layer.cornerRadius = 10 }
    }
    @IBOutlet private weak var textView: UITextView!
    
    weak var delegate: StudyRecordMemoVCDelegate?
    var inputtedMemo = ""
    private var oldInputtedMemo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        oldInputtedMemo = inputtedMemo
        
    }
    
    private func setupTextView() {
        textView.text = inputtedMemo
        textView.delegate = self
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
    }
    
    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        if inputtedMemo == oldInputtedMemo {
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "保存せずにメモを閉じますか", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "保存する", style: .default, handler: { _ in
                self.delegate?.savedMemo(memo: self.inputtedMemo)
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        self.delegate?.savedMemo(memo: self.inputtedMemo)
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextViewDelegate
extension StudyRecordMemoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        inputtedMemo = textView.text
    }
    
}


