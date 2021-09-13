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
    
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var decisionButton: UIButton!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var textView: UITextView!
    
    weak var delegate: StudyRecordMemoVCDelegate?
    var inputtedMemo = ""
    private var oldInputtedMemo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setupBaseView()
        setupTitleLabel()
        setupDidmissButton()
        setupDecisionButton()
        oldInputtedMemo = inputtedMemo
        
    }
    
}

// MARK: - IBAction func
private extension StudyRecordMemoViewController {
    
    @IBAction func dismissButtonDidTapped(_ sender: Any) {
        if inputtedMemo == oldInputtedMemo {
            dismiss(animated: true)
        } else {
            showAlert()
        }
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        self.delegate?.savedMemo(memo: self.inputtedMemo)
        dismiss(animated: true)
    }
    
}

// MARK: - func
private extension StudyRecordMemoViewController {
    
    func showAlert() {
        let alert = Alert.create(title: LocalizeKey.doYouWantToCloseTheNoteWithoutSaving.localizedString())
            .addAction(title: LocalizeKey.close.localizedString(), style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: LocalizeKey.save.localizedString()) {
                self.delegate?.savedMemo(memo: self.inputtedMemo)
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
}

// MARK: - UITextViewDelegate
extension StudyRecordMemoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        inputtedMemo = textView.text
    }
    
}

// MARK: - setup
private extension StudyRecordMemoViewController {
    
    func setupTextView() {
        textView.text = inputtedMemo
        textView.delegate = self
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
    }
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 10
    }
    
    func setupDidmissButton() {
        dismissButton.setTitle(LocalizeKey.close.localizedString())
    }
    
    func setupTitleLabel() {
        titleLabel.text = LocalizeKey.graphColor.localizedString()
    }
    
    func setupDecisionButton() {
        decisionButton.setTitle(LocalizeKey.decision.localizedString())
    }
    
}
