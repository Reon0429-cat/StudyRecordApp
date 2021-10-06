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
    @IBOutlet private weak var textViewBaseView: UIView!
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setBorderColor()
        }
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
        let alert = Alert.create(title: L10n.doYouWantToCloseTheNoteWithoutSaving)
            .addAction(title: L10n.close, style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.save) {
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
        textView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemGroupedBackground)
        textView.textColor = .dynamicColor(light: .black, dark: .white)
        textView.tintColor = .dynamicColor(light: .black, dark: .white)
        
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
    }
    
    func setBorderColor() {
        textViewBaseView.layer.cornerRadius = 10
        textViewBaseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                        dark: .accentColor ?? .white),
                                   radius: 3,
                                   opacity: 0.8,
                                   size: (width: 2, height: 2))
    }
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 10
    }
    
    func setupDidmissButton() {
        dismissButton.setTitle(L10n.close)
    }
    
    func setupTitleLabel() {
        titleLabel.text = L10n.largeMemo
    }
    
    func setupDecisionButton() {
        decisionButton.setTitle(L10n.decision)
    }
    
}
