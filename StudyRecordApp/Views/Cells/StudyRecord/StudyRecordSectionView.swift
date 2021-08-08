//
//  StudyRecordSectionView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

private enum MemoState {
    case expanded
    case shrinked
    var title: String {
        switch self {
            case .expanded: return "▲ メモ"
            case .shrinked: return "▼ メモ"
        }
    }
    mutating func toggle() {
        switch self {
            case .expanded: self = .shrinked
            case .shrinked: self = .expanded
        }
    }
}

protocol StudyRecordSectionViewDelegate: AnyObject {
    func baseViewDidTapped(section: Int)
    func memoButtonDidTapped(section: Int)
    func deleteButtonDidTappped(section: Int)
    func sortButtonDidTapped(section: Int)
}

final class StudyRecordSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var sortButton: UIButton!
    
    private var memoState: MemoState = .shrinked
    weak var delegate: StudyRecordSectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBaseView()
        deleteButton.isHidden = true
        sortButton.isHidden = true
        
    }
    
    @IBAction private func memoButtonDidTapped(_ sender: Any) {
        memoState.toggle()
        memoButton.setTitle(memoState.title)
        delegate?.memoButtonDidTapped(section: self.tag)
    }
    
    func configure(record: Record) {
        setupTitleLabel(record: record)
        setupTimeLabel(record: record)
        setupMemoButton(record: record)
    }
    
    func changeMode(isEditing: Bool) {
        if isEditing {
            todayStudyTimeLabel.isHidden = true
            totalStudyTimeLabel.isHidden = true
            deleteButton.isHidden = false
            sortButton.isHidden = false
        } else {
            todayStudyTimeLabel.isHidden = false
            totalStudyTimeLabel.isHidden = false
            deleteButton.isHidden = true
            sortButton.isHidden = true
        }
    }
    
    @objc private func baseViewEvent() {
        delegate?.baseViewDidTapped(section: self.tag)
    }
    
    @IBAction private func deleteButtonDidTappped(_ sender: Any) {
        delegate?.deleteButtonDidTappped(section: self.tag)
    }

    @IBAction private func sortButtonDidTappped(_ sender: Any) {
        delegate?.sortButtonDidTapped(section: self.tag)
    }
    
}

// MARK: - setup
private extension StudyRecordSectionView {
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 10
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(baseViewEvent))
        baseView.addGestureRecognizer(tapGR)
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupTimeLabel(record: Record) {
        todayStudyTimeLabel.text = {
            if record.time.today >= 60 {
                return "今日: \(record.time.today / 60)時間"
            }
            return "今日: \(record.time.today)分"
        }()
        totalStudyTimeLabel.text = {
            if record.time.total >= 60 {
                return "合計: \(record.time.total / 60)時間"
            }
            return "合計: \(record.time.total)分"
        }()
    }
    
    func setupMemoButton(record: Record) {
        memoState = record.isExpanded ? .expanded : .shrinked
        memoButton.setTitle(memoState.title)
        if record.memo.isEmpty {
            memoButton.isHidden = true
        } else {
            memoButton.isHidden = false
        }
    }
    
}
