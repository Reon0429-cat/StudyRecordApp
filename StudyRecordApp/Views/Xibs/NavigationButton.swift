//
//  NavigationButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/20.
//

import UIKit

final class NavigationButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = UINib(
            nibName: String(describing: type(of: self)),
            bundle: nil
        ).instantiate(
            withOwner: self,
            options: nil
        ).first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}
