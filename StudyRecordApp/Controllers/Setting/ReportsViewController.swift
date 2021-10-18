//
//  ReportsViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/18.
//

import UIKit

final class ReportsViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var textViewBaseView: UIView!
    @IBOutlet private weak var textView: PlaceHolderTextView!
    @IBOutlet private weak var sendButton: CustomButton!
    @IBOutlet private weak var attentionLabel: UILabel!
    
    private let draftedTextKey = "draftedTextKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setupSendButton()
        setupSubCustomNavigationBar()
        setupAttentionLabel()
        setBorderColor()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setBorderColor()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - IBAction func
private extension ReportsViewController {
    
    @IBAction func sendButtonDidTapped(_ sender: Any) {
        print("DEBUG_PRINT: ", #function)
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension ReportsViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        if textView.text.isEmpty {
            UserDefaults.standard.set(nil, forKey: self.draftedTextKey)
            dismiss(animated: true)
        } else {
            let alert = Alert.create(title: L10n.doYouWantToCloseWithoutSaving)
                .addAction(title: L10n.close) {
                    UserDefaults.standard.set(nil, forKey: self.draftedTextKey)
                    self.dismiss(animated: true)
                }
                .addAction(title: L10n.save) {
                    let text = self.textView.text
                    UserDefaults.standard.set(text, forKey: self.draftedTextKey)
                    self.dismiss(animated: true)
                }
            present(alert, animated: true)
        }
    }
    
    var navTitle: String {
        return L10n.reports
    }
    
}

// MARK: - UITextViewDelegate
extension ReportsViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isEnabled = !textView.text.isEmpty
        sendButton.changeState(isEnabled: isEnabled)
    }
    
}

// MARK: - setup
private extension ReportsViewController {
    
    func setupTextView() {
        textView.delegate = self
        textView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemGroupedBackground)
        textView.textColor = .dynamicColor(light: .black, dark: .white)
        textView.tintColor = .dynamicColor(light: .black, dark: .white)
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
        if let text = UserDefaults.standard.string(forKey: draftedTextKey) {
            textView.text = text
        }
        textView.placeHolder = L10n.reportsDetail
        textView.placeHolder(isHidden: !textView.text.isEmpty)
    }
    
    func setBorderColor() {
        textViewBaseView.layer.cornerRadius = 10
        textViewBaseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                        dark: .accentColor ?? .white),
                                   radius: 3,
                                   opacity: 0.8,
                                   size: (width: 2, height: 2))
    }
    
    func setupSendButton() {
        let isEnabled = !textView.text.isEmpty
        sendButton.changeState(isEnabled: isEnabled)
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
    func setupAttentionLabel() {
        attentionLabel.text = L10n.reportAttention
    }
    
}
