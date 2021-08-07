//
//  StudyRecordSectionView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

protocol StudyRecordSectionViewDelegate: AnyObject {
    func baseViewDidTapped()
}

final class StudyRecordSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    
    var didClickedButton: (() -> Void)?
    private var isExpanded = false
    var delegate: StudyRecordSectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 10
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(baseViewDidTapped))
        baseView.addGestureRecognizer(tapGR)
        
    }
    
    @IBAction private func memoButtonDidTapped(_ sender: Any) {
        isExpanded.toggle()
        memoButton.setTitle("\(isExpanded ? "▼" : "▲") メモ")
        didClickedButton?()
    }
    
    func configure(record: Record,
                   didClickedButton: @escaping () -> Void) {
        self.didClickedButton = didClickedButton
        titleLabel.text = record.title
        todayStudyTimeLabel.text = "今日: \(record.time.today)分"
        totalStudyTimeLabel.text = "合計: \(record.time.total)分"
        isExpanded = record.isExpanded
        memoButton.setTitle("\(isExpanded ? "▼" : "▲") メモ")
        if record.memo.isEmpty {
            memoButton.isHidden = true
        } else {
            memoButton.isHidden = false
        }
    }
    
    @objc private func baseViewDidTapped() {
        delegate?.baseViewDidTapped()
    }
    
}
