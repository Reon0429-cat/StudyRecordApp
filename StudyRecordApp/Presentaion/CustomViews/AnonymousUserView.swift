//
//  AnonymousUserView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/24.
//

import Foundation
import UIKit

final class AnonymousUserView: UIView {
    
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var signUpButton: CustomButton!
    
    var signUpButtonEvent: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNib()
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNib()
        setup()
        
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
    
    @IBAction private func signUpButtonDidTapped(_ sender: Any) {
        signUpButtonEvent?()
    }
    
    private func setup() {
        detailLabel.text = L10n.onlyAvailableNotAnonymousUser
        signUpButton.setTitle(L10n.signUp)
    }
    
}
