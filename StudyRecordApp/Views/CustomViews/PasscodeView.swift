//
//  PasscodeView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import UIKit

enum PasscodeInputState {
    case first(_ onceInputPasscode: String)
    case confirmation(_ onceInputPasscode: String,
                      _ twiceInputPasscode: String)
}

protocol PasscodeViewDelegate: AnyObject {
    func input(inputState: PasscodeInputState)
}

final class PasscodeView: UIView {
    
    @IBOutlet private weak var keyboardStackView: UIStackView!
    @IBOutlet private weak var firstLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var thirdLabel: UILabel!
    @IBOutlet private weak var fourthLabel: UILabel!
    @IBOutlet private var keyboardButtons: [UIButton]!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var inputCountLabel: UILabel!
    
    weak var delegate: PasscodeViewDelegate?
    private enum LabelType {
        case first(_ text: String)
        case second(_ text: String)
        case third(_ text: String)
        case fourth(_ text: String)
    }
    private var labelType: LabelType = .first("")
    private var inputState: PasscodeInputState = .first("")
    
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
        setupClearButton()
        
    }
    
    func changeInputLabelText(_ text: String) {
        inputCountLabel.text = text
        clearInputLabel()
    }
    
    func clearAll() {
        labelType = .first("")
        inputState = .first("")
        clearInputLabel()
    }
    
    private func clearInputLabel() {
        firstLabel.text = "◯"
        secondLabel.text = "◯"
        thirdLabel.text = "◯"
        fourthLabel.text = "◯"
    }
    
}

// MARK: - IBAction func
private extension PasscodeView {
    
    @IBAction func keyboardButtonDidTapped(_ sender: UIButton) {
        switch labelType {
            case .first:
                firstLabel.text = "●"
                labelType = .second("\(sender.tag)")
            case .second(let firstText):
                firstLabel.text = "●"
                secondLabel.text = "●"
                labelType = .third(firstText + "\(sender.tag)")
            case .third(let secondText):
                thirdLabel.text = "●"
                labelType = .fourth(secondText + "\(sender.tag)")
            case .fourth(let thirdText):
                fourthLabel.text = "●"
                labelType = .first("")
                let inputtedPasscode = thirdText + "\(sender.tag)"
                switch inputState {
                    case .first:
                        delegate?.input(inputState: .first(inputtedPasscode))
                        inputState = .confirmation(inputtedPasscode, "")
                    case .confirmation(let oncePasscode, _):
                        delegate?.input(inputState: .confirmation(oncePasscode,
                                                                  inputtedPasscode))
                        inputState = .first("")
                }
        }
    }
    
    @IBAction func clearButtonDidTapped(_ sender: Any) {
        
        switch labelType {
            case .first:
                break
            case .second(let firstText):
                firstLabel.text = "◯"
                labelType = .first(String(firstText.dropLast()))
            case .third(let secondText):
                secondLabel.text = "◯"
                labelType = .second(String(secondText.dropLast()))
            case .fourth(let thirdText):
                thirdLabel.text = "◯"
                labelType = .third(String(thirdText.dropLast()))
        }
    }
    
}

// MARK: - setup
private extension PasscodeView {
    
    func setupKeyboardButtons() {
        keyboardButtons.forEach { button in
            button.cutToCircle()
            button.setGradation()
        }
    }
    
    func setupClearButton() {
        clearButton.cutToCircle()
        clearButton.setGradation()
    }
    
}
