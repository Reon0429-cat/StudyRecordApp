//
//  PasscodeView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import UIKit

protocol PasscodeViewDelegate: AnyObject {
    func validate(passcode: String)
}

final class PasscodeView: UIView {
    
    @IBOutlet private weak var keyboardStackView: UIStackView!
    @IBOutlet private weak var firstLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var thirdLabel: UILabel!
    @IBOutlet private weak var fourthLabel: UILabel!
    @IBOutlet private var keyboardButtons: [UIButton]!
    
    weak var delegate: PasscodeViewDelegate?
    private var tappedCount = 0
    private var inputtedPasscode = ""
    private enum State: Int {
        case first
        case second
        case third
        case fourth
    }
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
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupKeyboardButtons()
        
    }
    
    func failure() {
        tappedCount = 0
        inputtedPasscode = ""
        firstLabel.text = "◯"
        secondLabel.text = "◯"
        thirdLabel.text = "◯"
        fourthLabel.text = "◯"
    }
    
}

// MARK: - IBAction func
private extension PasscodeView {
    
    @IBAction func keyboardButtonDidTapped(_ sender: UIButton) {
        inputtedPasscode += String(sender.tag)
        let state = State(rawValue: tappedCount) ?? .first
        switch state {
            case .first:
                firstLabel.text = "●"
            case .second:
                secondLabel.text = "●"
            case .third:
                thirdLabel.text = "●"
            case .fourth:
                fourthLabel.text = "●"
                delegate?.validate(passcode: inputtedPasscode)
        }
        tappedCount += 1
    }
    
}

// MARK: - setup
private extension PasscodeView {
    
    func setupKeyboardButtons() {
        keyboardButtons.forEach { button in
            button.cutToCircle()
        }
    }
    
}
