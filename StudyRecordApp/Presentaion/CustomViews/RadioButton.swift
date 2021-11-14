//
//  RadioButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/01.
//

import UIKit

final class RadioButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()

    }

    private func setup() {}

    func setImage(isFilled: Bool) {
        self.setImage(radioButtonImage(isFilled: isFilled))
    }

    private func radioButtonImage(isFilled: Bool) -> UIImage {
        let imageName: SystemName = {
            if isFilled {
                return .recordCircle
            }
            return .circle
        }()
        return UIImage(systemName: imageName)
    }

}
