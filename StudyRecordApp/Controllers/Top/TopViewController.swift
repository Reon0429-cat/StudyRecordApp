//
//  TopViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/14.
//

import UIKit

final class TopViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var editButton: NavigationButton!
    @IBOutlet private weak var editButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomSeparatorView: UIView!
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var middleWaveView: WaveView!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var verticalSeparatorView: UIView!
    
    private struct LayoutConstant {
        static let titleLabelLeft: CGFloat = 20
        static let editButtonRight: CGFloat = 70
        static let addButtonRight: CGFloat = 50
    }
    private var screenType: ScreenType = .record
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private var pageViewController: UIPageViewController!
    private var tabBarCollectionVC: TabBarCollectionViewController!
    private var viewControllers = [UIViewController]()
    private var currentPageIndex = 0
    
    override func loadView() {
        super.loadView()
        
        setupAnimation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
        setupTabBarCollectionView()
        setupPageViews()
        setupTitleLabel()
        setupAddButton()
        setupEditButton()
        setupSortButton()
        setAnimation()
        setupWaveViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if !self.userUseCase.isLoggedIn {
                self.present(LoginAndSignUpViewController.self,
                             modalPresentationStyle: .fullScreen)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddButtonLayout()
        setupTitleLabelLayout()
        setupSeparatorViewLayout()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? UIPageViewController {
            self.pageViewController = pageViewController
        }
        if let tabBarCollectionVC = segue.destination as? TabBarCollectionViewController {
            self.tabBarCollectionVC = tabBarCollectionVC
        }
    }
    
}

// MARK: - IBAction func
private extension TopViewController {
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        switch screenType {
            case .record:
                present(AdditionalStudyRecordViewController.self,
                        modalPresentationStyle: .fullScreen)
            case .goal:
                present(AdditionalGoalViewController.self,
                        modalPresentationStyle: .fullScreen)
            case .graph:
                break
            case .countDown:
                break
            case .setting:
                break
        }
    }
    
    @IBAction func sortButtonDidTapped(_ sender: Any) {
        switch screenType {
            case .record:
                present(StudyRecordSortViewController.self,
                        modalPresentationStyle: .fullScreen)
            case .goal:
                break
            case .graph:
                break
            case .countDown:
                break
            case .setting:
                break
        }
    }
    
}

// MARK: - func
private extension TopViewController {
    
    func changeEditMode(type: NavigationButtonType) {
        editButton.changeType(to: type)
        if let studyRecordVC = viewControllers.first as? StudyRecordViewController {
            studyRecordVC.reloadTableView()
        }
        sortButton.toggleFade()
    }
    
    func screenDidChanged(item: Int) {
        screenType = ScreenType.allCases[item]
        tabBarCollectionVC.scroll(at: item)
        UIView.animate(withDuration: 0) {
            self.setTitleLabelAnimation(index: item)
        } completion: { _ in
            self.currentPageIndex = item
        }
    }
    
    func setTitleLabelAnimation(index: Int) {
        if index < self.currentPageIndex {
            self.titleLabel.alpha = 0
            self.titleLabelLeftConstraint.constant -= LayoutConstant.titleLabelLeft
            self.titleLabel.text = self.screenType.title
            UIView.animate(deadlineFromNow: 0.15) {
                self.titleLabel.text = self.screenType.title
                self.titleLabelLeftConstraint.constant += LayoutConstant.titleLabelLeft
                self.titleLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        if index > self.currentPageIndex {
            self.titleLabel.alpha = 0
            self.titleLabelLeftConstraint.constant += LayoutConstant.titleLabelLeft
            self.titleLabel.text = self.screenType.title
            UIView.animate(deadlineFromNow: 0.15) {
                self.titleLabelLeftConstraint.constant -= LayoutConstant.titleLabelLeft
                self.titleLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func pageVCSetVC(at item: Int, direction: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers([viewControllers[item]],
                                              direction: direction,
                                              animated: true,
                                              completion: nil)
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

// MARK: - TabBarCollectionViewDelegate
extension TopViewController: TabBarCollectionVCDelegate {
    
    func collectionViewDidTapped(index: Int) {
        pageVCSetVC(at: index,
                    direction: currentPageIndex < index ? .forward : .reverse)
    }
    
}

// MARK: - 共通のdelegate
extension TopViewController {
    
    func screenDidPresented(index: Int) {
        screenDidChanged(item: index)
        switch screenType {
            case .record:
                editButton.setFade(.in)
                addButton.setFade(.in)
            case .goal:
                editButton.setFade(.in)
                addButton.setFade(.in)
            case .graph:
                editButton.setFade(.in)
                addButton.setFade(.in)
            case .countDown:
                editButton.setFade(.in)
                addButton.setFade(.in)
            case .setting:
                editButton.setFade(.out)
                addButton.setFade(.out)
        }
    }
    
}

// MARK: - StudyRecordVCDelegate
extension TopViewController: StudyRecordVCDelegate {
    
    var isEdit: Bool {
        editButton.isType(.completion)
    }
    
    func viewWillAppear(records: [Record]) {
        editButton.isEnabled(!records.isEmpty)
    }
    
    func deleteButtonDidTappped(records: [Record]) {
        if records.isEmpty {
            changeEditMode(type: .edit)
        }
        editButton.isEnabled(!records.isEmpty)
    }
    
    func baseViewLongPressDidRecognized() {
        if editButton.isType(.edit) {
            changeEditMode(type: .completion)
        }
    }
    
}

// MARK: - GoalVCDelegate
extension TopViewController: GoalVCDelegate {
    
}

// MARK: - GraphVCDelegate
extension TopViewController: GraphVCDelegate {
    
}

// MARK: - CountDownVCDelegate
extension TopViewController: CountDownVCDelegate {
    
}

// MARK: - SettingVCDelegate
extension TopViewController: SettingVCDelegate {
    
    func loginAndSignUpVCDidShowed() {
        pageVCSetVC(at: 0, direction: .reverse)
        screenDidChanged(item: 0)
    }
    
}

// MARK: - NavigationButtonDelegate
extension TopViewController: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        switch screenType {
            case .record:
                changeEditMode(type: {
                    switch type {
                        case .edit: return .completion
                        default: return .edit
                    }
                }())
            case .goal:
                break
            case .graph:
                break
            case .countDown:
                break
            case .setting:
                break
        }
    }
    
}

// MARK: - setup
private extension TopViewController {
    
    func setupPageViewController() {
        pageViewController.dataSource = self
    }
    
    func setupTabBarCollectionView() {
        tabBarCollectionVC.delegate = self
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
        viewControllers = [studyRecordVC, goalVC, graphVC, countDownVC, settingVC]
        viewControllers.enumerated().forEach { $1.view.tag = $0 }
        pageViewController.setViewControllers([viewControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
    }
    
    func setupTitleLabel() {
        titleLabel.text = screenType.title
    }
    
    func setupAddButton() {
        let image = UIImage(systemName: "plus")!.setColor(.white)
        addButton.setImage(image)
        addButton.setGradation(locations: [0, 0.9])
    }
    
    func setupEditButton() {
        editButton.delegate = self
        editButton.backgroundColor = .clear
        editButton.type = .edit
    }
    
    func setupSortButton() {
        sortButton.isHidden = true
        sortButton.alpha = 0
    }
    
    func setupWaveViews() {
        topWaveView.create(isFill: true, marginY: 60)
        middleWaveView.create(isFill: false, marginY: 20)
        bottomWaveView.create(isFill: false, marginY: 23)
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

// MARK: - setup layout
private extension TopViewController {
    
    func setupTitleLabelLayout() {
        titleLabel.setShadow(rect: (distance: 10, height: 5))
    }
    
    func setupAddButtonLayout() {
        addButton.setCircle()
    }
    
    func setupSeparatorViewLayout() {
        verticalSeparatorView.setGradation(colors: [.white, .black],
                                           startPoint: (x: 0, y: 0),
                                           endPoint: (x: 1, y: 1))
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
