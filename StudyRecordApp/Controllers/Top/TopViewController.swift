//
//  TopViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/14.
//

import UIKit

final class TopViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var editButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topSeparatorView: UIView!
    @IBOutlet private weak var middleSeparatorView: UIView!
    @IBOutlet private weak var bottomSeparatorView: UIView!
    @IBOutlet private weak var verticalSeparatorView: UIView!
    
    private struct LayoutConstant {
        static let titleLabelLeft: CGFloat = 100
        static let editButtonRight: CGFloat = -50
        static let addButtonRight: CGFloat = 50
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
    private var editButtonState: EditButtonState = .edit {
        didSet {
            editButton.setTitle(editButtonState.title)
        }
    }
    private var screenType: ScreenType = .record
    private func getScreenType(item: Int) -> ScreenType {
        guard let screenType = ScreenType(rawValue: item) else {
            fatalError()
        }
        return screenType
    }
    private var pageViewController: UIPageViewController!
    private var viewControllers = [UIViewController]()
    private var currentPageIndex = 0
    
    override func loadView() {
        super.loadView()
        
        setupAnimation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
        setupPageViews()
        setupCollectionView()
        setupTitleLabel()
        setupSortButton()
        setAnimation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddButton()
        setupEditButton()
        setupSeparators()
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
        switch screenType {
            case .record:
                let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
                additionalStudyRecordVC.modalPresentationStyle = .fullScreen
                present(additionalStudyRecordVC, animated: true, completion: nil)
            default:
                break
        }
    }
    
    @IBAction private func editButtonDidTapped(_ sender: Any) {
        changeEditMode()
    }
    
    @IBAction private func sortButtonDidTapped(_ sender: Any) {
        let studyRecordSortVC = StudyRecordSortViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: studyRecordSortVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? UIPageViewController {
            self.pageViewController = pageViewController
        }
    }
    
    private func changeEditMode() {
        editButtonState.toggle()
        NotificationCenter.default.post(name: .editButtonDidTapped,
                                        object: nil)
        if sortButton.isHidden {
            sortButton.setFade(.in)
        } else {
            sortButton.setFade(.out)
        }
    }
    
    private func screenDidChanged(item: Int) {
        screenType = getScreenType(item: item)
        scrollCollectionViewItem(at: item)
        currentPageIndex = item
        reloadViews()
    }
    
    private func scrollCollectionViewItem(at item: Int) {
        collectionView.scrollToItem(at: IndexPath(item: item,
                                                  section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
    private func reloadViews() {
        titleLabel.text = screenType.title
        if screenType == .setting {
            editButton.isHidden = true
            addButton.isHidden = true
        } else {
            editButton.isHidden = false
            addButton.isHidden = false
        }
        if screenType == .countDown {
            titleLabel.font = .boldSystemFont(ofSize: 30)
        } else {
            titleLabel.font = .boldSystemFont(ofSize: 40)
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension TopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        pageViewController.setViewControllers([viewControllers[indexPath.item]],
                                              direction: currentPageIndex < indexPath.item ? .forward : .reverse,
                                              animated: true,
                                              completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension TopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return ScreenType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: ScreenTransitionCollectionViewCell.self,
                                                            indexPath: indexPath)
        let screenType = getScreenType(item: indexPath.item)
        cell.configure(title: screenType.title)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 15
        let verticalSpace: CGFloat = 15
        let width = collectionView.frame.size.width / 2 - horizontalSpace * 2
        let height = collectionView.frame.size.height - verticalSpace * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension TopViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(of: currentVC) else { return }
        currentPageIndex = index
    }
}

// MARK: - UIPageViewControllerDataSource
extension TopViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              viewControllers.count - 1 > index else { return nil }
        return viewControllers[index + 1]
    }
    
}

// MARK: - StudyRecordVCDelegate
extension TopViewController: StudyRecordVCDelegate {
    
    var isEdit: Bool {
        editButtonState == .completion
    }
    
    func viewWillAppear(records: [Record], index: Int) {
        if records.count == 0 {
            editButton.isEnabled = false
        } else {
            editButton.isEnabled = true
        }
        screenDidChanged(item: index)
    }
    
    func deleteButtonDidTappped(records: [Record]) {
        if records.count == 0 {
            editButtonState = .edit
            editButton.isEnabled = false
        } else {
            editButton.isEnabled = true
        }
    }
    
    func baseViewLongPressDidRecognized() {
        if editButtonState == .edit {
            changeEditMode()
        }
    }
    
}

extension TopViewController: GoalVCDelegate, GraphVCDelegate, CountDownVCDelegate, SettingVCDelegate {
    
    func viewWillAppear(index: Int) {
        screenDidChanged(item: index)
    }
    
}

// MARK: - setup
private extension TopViewController {
    
    func setupPageViewController() {
        pageViewController.dataSource = self
    }
    
    func setupPageViews() {
        let studyRecordVC = StudyRecordViewController.instantiate()
        studyRecordVC.delegate = self
        let goalVC = GoalViewController.instantiate()
        goalVC.delegate = self
        let graphVC = GraphViewController.instantiate()
        graphVC.delegate = self
        let countDownVC = CountDownViewController.instantiate()
        countDownVC.delegate = self
        let settingVC = SettingViewController.instantiate()
        settingVC.delegate = self
        viewControllers.append(studyRecordVC)
        viewControllers.append(goalVC)
        viewControllers.append(graphVC)
        viewControllers.append(countDownVC)
        viewControllers.append(settingVC)
        viewControllers.enumerated().forEach { $1.view.tag = $0 }
        pageViewController.setViewControllers([viewControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(ScreenTransitionCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.collectionViewLayout = layout
    }
    
    func setupTitleLabel() {
        titleLabel.text = screenType.title
    }
    
    func setupAddButton() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupEditButton() {
        editButton.setMaskedCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner])
    }
    
    func setupSortButton() {
        sortButton.isHidden = true
        sortButton.alpha = 0
    }
    
    func setupSeparators() {
        topSeparatorView.backgroundColor = .black
        middleSeparatorView.backgroundColor = .black
        bottomSeparatorView.backgroundColor = .black
        verticalSeparatorView.backgroundColor = .black
    }
    
    func setupAnimation() {
        titleLabelLeftConstraint.constant -= LayoutConstant.titleLabelLeft
        titleLabel.alpha = 0
        
        editButtonRightConstraint.constant -= LayoutConstant.editButtonRight
        editButton.alpha = 0
        
        addButtonRightConstraint.constant -= LayoutConstant.addButtonRight
        addButton.alpha = 0
    }
    
}

private extension TopViewController {
    
    func setAnimation() {
        UIView.animate(deadlineFromNow: 0.15) {
            self.titleLabelLeftConstraint.constant += LayoutConstant.titleLabelLeft
            self.titleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(deadlineFromNow: 0.4) {
            self.editButtonRightConstraint.constant += LayoutConstant.editButtonRight
            self.editButton.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(deadlineFromNow: 0.15) {
            self.addButtonRightConstraint.constant += LayoutConstant.addButtonRight
            self.addButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}

private extension UIView {
    
    static func animate(deadlineFromNow: Double,
                        _ animation: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadlineFromNow) {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: []) {
                animation()
            }
        }
    }
    
}
