//
//  TopViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/14.
//

import UIKit

struct Constant {
    
    static let borderWidth: CGFloat = 1
    
    struct CollectionView {
        static let margin: CGFloat = 15
    }
    
    struct TableView {
        static let headerHeight: CGFloat = 120
    }
    
}

private enum ScreenType: CaseIterable {
    case record
    case goal
    case graph
    case countDown
    case setting
    
    var title: String {
        switch self {
            case .record: return "記録"
            case .goal: return "目標"
            case .graph: return "グラフ"
            case .countDown: return "カウント\nダウン"
            case .setting: return "設定"
        }
    }
}

private enum EditButtonState {
    case edit
    case completion
    var title: String {
        switch self {
            case .edit: return "編集"
            case .completion: return "完了"
        }
    }
    mutating func toggle() {
        switch self {
            case .edit: self = .completion
            case .completion: self = .edit
        }
    }
}

final class TopViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var parentContainerView: UIView!
    @IBOutlet private weak var studyRecordContainerView: UIView!
    @IBOutlet private weak var goalContainerView: UIView!
    @IBOutlet private weak var graphContainerView: UIView!
    @IBOutlet private weak var countDownContainerView: UIView!
    @IBOutlet private weak var settingContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var topSeparatorView: UIView!
    @IBOutlet private weak var middleSeparatorView: UIView!
    @IBOutlet private weak var bottomSeparatorView: UIView!
    @IBOutlet private weak var verticalSeparatorView: UIView!
    
    private var editButtonState: EditButtonState = .edit {
        didSet {
            editButton.setTitle(editButtonState.title)
        }
    }
    private var screenTypes = ScreenType.allCases
    private var containers = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerViews()
        setupCollectionView()
        setupSeparators()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddButton()
        setupEditButton()
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
        //        let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
        //        let navigationController = UINavigationController(rootViewController: additionalStudyRecordVC)
        //        navigationController.modalPresentationStyle = .fullScreen
        //        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func editButtonDidTapped(_ sender: Any) {
        editButtonState.toggle()
    }
    
}

// MARK: - UICollectionViewDelegate
extension TopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let containerView = containers[indexPath.item]
        parentContainerView.bringSubviewToFront(containerView)
    }
    
}

// MARK: - UICollectionViewDataSource
extension TopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return screenTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: ScreenTransitionCollectionViewCell.self,
                                                            indexPath: indexPath)
        let screenType = screenTypes[indexPath.item]
        cell.configure(title: screenType.title)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace = Constant.CollectionView.margin
        let verticalSpace = Constant.CollectionView.margin
        let width = collectionView.frame.size.width / 2 - horizontalSpace * 2
        let height = collectionView.frame.size.height - verticalSpace * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.CollectionView.margin
    }
    
}

// MARK: - setup
private extension TopViewController {
    
    func setupContainerViews() {
        containers.append(studyRecordContainerView)
        containers.append(goalContainerView)
        containers.append(graphContainerView)
        containers.append(countDownContainerView)
        containers.append(settingContainerView)
        parentContainerView.bringSubviewToFront(studyRecordContainerView)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(ScreenTransitionCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constant.CollectionView.margin,
                                           bottom: 0,
                                           right: Constant.CollectionView.margin)
        collectionView.collectionViewLayout = layout
    }
    
    func setupAddButton() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.borderWidth = Constant.borderWidth
        addButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupEditButton() {
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        editButton.layer.borderWidth = Constant.borderWidth
        editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupSeparators() {
        topSeparatorView.backgroundColor = .black
        middleSeparatorView.backgroundColor = .black
        bottomSeparatorView.backgroundColor = .black
        verticalSeparatorView.backgroundColor = .black
    }
    
}