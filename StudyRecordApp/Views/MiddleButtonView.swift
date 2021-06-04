//
//  MiddleButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class MiddleButtonView: UIView {

    @IBOutlet weak var middleButton: UIButton! {
        didSet {
            middleButton.imageView?.contentMode = .scaleAspectFit
            middleButton.contentHorizontalAlignment = .fill
            middleButton.contentVerticalAlignment = .fill
            middleButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
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
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction private func middleButtonDidTapped(_ sender: Any) {
        print(#function)
    }
    
}
