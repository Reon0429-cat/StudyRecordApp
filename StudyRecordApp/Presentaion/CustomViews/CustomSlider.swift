//
//  CustomSlider.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import UIKit

final class CustomSlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setObserver()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
        setObserver()

    }

    private func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedThemeColor),
                                               name: .changedThemeColor,
                                               object: nil)
    }

    @objc
    private func changedThemeColor() {
        setupColor()
    }

    private func setup() {
        setupColor()
    }

    private func setupColor() {
        backgroundColor = .clear
        tintColor = .black
        minimumTrackTintColor = .dynamicColor(light: .black,
                                              dark: .white)
        thumbTintColor = .dynamicColor(light: .black,
                                       dark: .white)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.cutToCircle()

    }

}
