//
//  ReportThankYouView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/18.
//

import Foundation
import UIKit

final class ReportThankYouView: UIView {

    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }

    private func loadNib() {
        guard let view = UINib(nibName: String(describing: type(of: self)),
                               bundle: nil)
            .instantiate(withOwner: self,
                         options: nil)
            .first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        setup()
    }

    private func setup() {
        baseView.layer.cornerRadius = 10
        baseView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemBackground)
        setColor()

        titleLabel.text = L10n.reportThankYouTitle
    }

    func setColor() {
        baseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                dark: .accentColor ?? .white))
    }

}
