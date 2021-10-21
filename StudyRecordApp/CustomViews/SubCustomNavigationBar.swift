//
//  SubCustomNavigationBar.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import UIKit

protocol SubCustomNavigationBarDelegate: AnyObject {
    func saveButtonDidTapped()
    func dismissButtonDidTapped()
    var navTitle: String { get }
}

final class SubCustomNavigationBar: UIView {
    
    @IBOutlet private weak var waveView: WaveView!
    @IBOutlet private weak var dismissButton: NavigationButton!
    @IBOutlet private weak var saveButton: NavigationButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: SubCustomNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = UINib(nibName: String(describing: type(of: self)),
                               bundle: nil)
                .instantiate(withOwner: self,
                             options: nil)
                .first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
        
        setupDismissButton()
        setupSaveButton()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupWaveView()
        setupTitleLabel()
        
    }
    
    func saveButton(isEnabled: Bool) {
        saveButton.isEnabled(isEnabled)
    }
    
    func saveButton(isHidden: Bool) {
        saveButton.isHidden = isHidden
    }
    
    func dismissButton(isHidden: Bool) {
        dismissButton.isHidden = isHidden
    }
    
}

// MARK: - NavigationButtonDelegate
extension SubCustomNavigationBar: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        switch type {
            case .save:
                delegate?.saveButtonDidTapped()
            case .dismiss:
                delegate?.dismissButtonDidTapped()
            default:
                break
        }
    }
    
}

// MARK: - setup
private extension SubCustomNavigationBar {
    
    func setupWaveView() {
        waveView.create(isFill: true, marginY: 60)
    }
    
    func setupDismissButton() {
        dismissButton.type = .dismiss
        dismissButton.delegate = self
        dismissButton.setTitle("")
    }
    
    func setupSaveButton() {
        saveButton.type = .save
        saveButton.delegate = self
        saveButton.setTitle("")
    }
    
    func setupTitleLabel() {
        titleLabel.text = delegate?.navTitle
    }
    
}
