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
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var middleWaveView: WaveView!
    @IBOutlet private weak var verticalSeparatorView: UIView!

    private struct LayoutConstant {
        static let titleLabelLeft: CGFloat = 20
        static let editButtonRight: CGFloat = 70
        static let addButtonRight: CGFloat = 50
    }

    private var screenType: ScreenType = .record
    private var pageViewController: UIPageViewController!
    private var tabBarCollectionVC: TabBarCollectionViewController!
    private var viewControllers = [UIViewController]()
    private var currentPageIndex = 0
    private var halfModalPresenter = HalfModalPresenter()
    private var reportThankYouView = ReportThankYouView()

    override func loadView() {
        super.loadView()

        setupAnimation()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupTabBarCollectionView()
        setupWaveViews()
        setupPageViews()
        setupTitleLabel()
        setupAddButton()
        setupEditButton()
        setupSortButton()
        setAnimation()
        setupObserver()
        setupReportThankYouView()
        self.view.backgroundColor = .dynamicColor(light: .white,
                                                  dark: .black)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupAddButtonLayout()
        setupTitleLabelLayout()
        setupSeparatorViewLayout()
        setupReportThankYouViewLayout()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setColor()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? UIPageViewController {
            self.pageViewController = pageViewController
        }
        if let tabBarCollectionVC = segue.destination as? TabBarCollectionViewController {
            self.tabBarCollectionVC = tabBarCollectionVC
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
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
        case .graph:
            break
        case .goal:
            present(AddAndEditGoalViewController.self,
                    modalPresentationStyle: .fullScreen) { vc in
                vc.selectedIndexPath = nil
                vc.goalScreenType = .add
            }
        case .setting:
            break
        }
    }

    @IBAction func sortButtonDidTapped(_ sender: Any) {
        switch screenType {
        case .record:
            present(StudyRecordSortViewController.self,
                    modalPresentationStyle: .fullScreen)
        case .graph:
            break
        case .goal:
            present(GoalSortViewController.self,
                    modalPresentationStyle: .fullScreen)
        case .setting:
            break
        }
    }

}

// MARK: - func
private extension TopViewController {

    func changeEditMode(type: NavigationButtonType) {
        editButton.changeType(to: type)
        let vc = viewControllers[screenType.rawValue]
        if let studyRecordVC = vc as? StudyRecordViewController {
            studyRecordVC.reloadTableView()
        }
        if let goalVC = vc as? GoalViewController {
            goalVC.reloadTableView()
        }
        if editButton.isType(.edit) {
            sortButton.setFade(.out)
        } else {
            sortButton.setFade(.in)
        }
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

    func changeAddButton(isEnabled: Bool) {
        let xmarkImage = UIImage(systemName: .xmark)
        let plusImage = UIImage(systemName: .plus)
        addButton.isEnabled = isEnabled
        if isEnabled {
            addButton.setImage(plusImage.setColor(.white))
        } else {
            addButton.setImage(xmarkImage.setColor(.systemRed))
        }
    }

    func pageVCSet(to screenType: ScreenType?,
                   completion: ((Bool) -> Void)? = nil) {
        guard let screenType = screenType else { return }
        pageViewController.setViewControllers(
            [viewControllers[screenType.rawValue]],
            direction: currentPageIndex < screenType.rawValue ? .forward : .reverse,
            animated: true,
            completion: completion
        )
    }

    func changeThemeColor() {
        setupWaveViews()
    }

    func setColor() {
        let image = UIImage(systemName: .arrowUpArrowDownCircleFill)
        let color: UIColor = .dynamicColor(light: .mainColor ?? .black,
                                           dark: .mainColor ?? .white)
        sortButton.setImage(image.setColor(color))
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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        pageVCSet(to: ScreenType(rawValue: indexPath.row))
    }

}

// MARK: - ScreenPresentationDelegate
extension TopViewController {

    func screenDidPresented(screenType: ScreenType,
                            isEnabledNavigationButton: Bool) {
        screenDidChanged(item: screenType.rawValue)
        editButton.isEnabled(isEnabledNavigationButton)
        changeEditMode(type: .edit)
        switch screenType {
        case .record:
            editButton.setFade(.in)
            editButton.changeTitle(editButton.type?.title ?? L10n.edit)
            changeAddButton(isEnabled: true)
        case .graph:
            editButton.setFade(.in)
            editButton.changeTitle(L10n.setting)
            changeAddButton(isEnabled: false)
        case .goal:
            editButton.setFade(.in)
            editButton.changeTitle(L10n.edit)
            changeAddButton(isEnabled: true)
        case .setting:
            editButton.setFade(.out)
            changeAddButton(isEnabled: false)
        }
    }

    func scroll(sourceScreenType: ScreenType,
                destinationScreenType: ScreenType,
                completion: (() -> Void)?) {
        pageVCSet(to: destinationScreenType) { _ in
            completion?()
        }
    }

}

// MARK: - EditButtonSelectable
extension TopViewController: EditButtonSelectable {

    var isEdit: Bool {
        editButton.isType(.completion)
    }

    func deleteButtonDidTappped(isEmpty: Bool) {
        if isEmpty {
            changeEditMode(type: .edit)
        }
        editButton.isEnabled(!isEmpty)
    }

    func baseViewLongPressDidRecognized() {
        if editButton.isType(.edit) {
            changeEditMode(type: .completion)
        }
    }

}

// MARK: - StudyRecordVCDelegate
extension TopViewController: StudyRecordVCDelegate {}

// MARK: - GoalVCDelegate
extension TopViewController: GoalVCDelegate {}

// MARK: - GraphVCDelegate
extension TopViewController: GraphVCDelegate {}

// MARK: - SettingVCDelegate
extension TopViewController: SettingVCDelegate {

    func presentThankYouView() {
        reportThankYouView.setFade(.in)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.reportThankYouView.setFade(.out)
        }
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
        case .graph:
            present(GraphKindSelectingViewController.self) { vc in
                self.halfModalPresenter.viewController = vc
            }
        case .goal:
            changeEditMode(type: {
                switch type {
                case .edit: return .completion
                default: return .edit
                }
            }())
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
        let graphVC = GraphViewController.instantiate()
        graphVC.delegate = self
        let goalVC = GoalViewController.instantiate()
        goalVC.delegate = self
        let settingVC = SettingViewController.instantiate()
        settingVC.delegate = self
        viewControllers = [studyRecordVC, graphVC, goalVC, settingVC]
        pageViewController.setViewControllers([viewControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
    }

    func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.text = screenType.title
    }

    func setupAddButton() {
        let plusImage = UIImage(systemName: .plus)
        addButton.setImage(plusImage.setColor(.white))
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
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        sortButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
    }

    func setupWaveViews() {
        topWaveView.create(isFill: true, marginY: 60)
        middleWaveView.create(isFill: false, marginY: 20)
    }

    func setupAnimation() {
        titleLabelLeftConstraint.constant -= LayoutConstant.titleLabelLeft
        titleLabel.alpha = 0

        editButtonRightConstraint.constant -= LayoutConstant.editButtonRight
        editButton.alpha = 0

        addButtonRightConstraint.constant -= LayoutConstant.addButtonRight
        addButton.alpha = 0
    }

    func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeToDefaultColor),
                                               name: .changedThemeColor,
                                               object: nil)
    }

    @objc
    func changeToDefaultColor() {
        changeThemeColor()
    }

    func setupReportThankYouView() {
        reportThankYouView.isHidden = true
    }

    func setupReportThankYouViewLayout() {
        reportThankYouView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(reportThankYouView)
        NSLayoutConstraint.activate([
            reportThankYouView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45),
            reportThankYouView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            reportThankYouView.heightAnchor.constraint(equalToConstant: 70),
            reportThankYouView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

}

// MARK: - setup layout
private extension TopViewController {

    func setupTitleLabelLayout() {
        titleLabel.setShadow(rect: (distance: 10, height: 5))
    }

    func setupAddButtonLayout() {
        addButton.cutToCircle()
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
