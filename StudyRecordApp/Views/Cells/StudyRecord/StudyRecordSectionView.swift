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
}

final class StudyRecordSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!

    private var memoState: MemoState = .shrinked
    weak var delegate: StudyRecordSectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBaseView()
        setupDeleteButton()
        
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
    
    func changeMode(isEdit: Bool) {
        if isEdit {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    @objc private func baseViewEvent() {
        delegate?.baseViewDidTapped(section: self.tag)
    }
    
    @IBAction private func deleteButtonDidTappped(_ sender: Any) {
        delegate?.deleteButtonDidTappped(section: self.tag)
    }
    
    private func isToday(_ history: History) -> Bool {
        let historyDate = "\(history.year)年\(history.month)月\(history.day)日"
        let today = Convert().stringFrom(Date(), format: "yyyy年M月d日")
        return historyDate == today
    }
    
}

// MARK: - setup
private extension StudyRecordSectionView {
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 20
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(baseViewEvent))
        baseView.addGestureRecognizer(tapGR)
        baseView.backgroundColor = .white
        baseView.layer.borderColor = UIColor.black.cgColor
        baseView.layer.borderWidth = 1
    }
    
    func setupDeleteButton() {
        deleteButton.isHidden = true
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.backgroundColor = .white
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupTimeLabel(record: Record) {
        var today: Int = {
            record.histories?.forEach { history in
                if isToday(history) {
                    today += (history.hour * 60 + history.minutes)
                }
            }
            return today
        }()
        todayStudyTimeLabel.text = {
            if today >= 60 {
                return "今日: \(today / 60)時間"
            }
            return "今日: \(today)分"
        }()
        var total: Int = {
            record.histories?.forEach { history in
                total += (history.hour * 60 + history.minutes)
            }
            return total
        }()
        totalStudyTimeLabel.text = {
            if total >= 60 {
                return "合計: \(total / 60)時間"
            }
            return "合計: \(total)分"
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
