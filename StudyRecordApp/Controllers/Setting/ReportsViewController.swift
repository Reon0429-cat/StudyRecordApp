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
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var sendButton: CustomButton!
    @IBOutlet private weak var attentionLabel: UILabel!
    
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

// MARK: - SubCustomNavigationBarDelegate
extension ReportsViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        if textView.text.isEmpty {
            dismiss(animated: true)
        } else {
            // MARK: - ToDo アラート
        }
    }
    
    var navTitle: String {
        return L10n.reports
    }
    
}

// MARK: - setup
private extension ReportsViewController {
    
    func setupTextView() {
        textView.text = ""
        // MARK: - ToDo 共通化
        // MARK: - ToDo 文字入れる(placefolder)
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
    
    func setupSendButton() {
        
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
    func setupAttentionLabel() {
        // MARK: - ToDo 国際化
        attentionLabel.text = ""
    }
    
}

