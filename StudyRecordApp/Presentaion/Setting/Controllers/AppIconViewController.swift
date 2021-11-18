//
//  AppIconViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

private enum IconBackground: Int, CaseIterable {
    case black
    case white
    var title: String {
        switch self {
        case .black: return L10n.black
        case .white: return L10n.white
        }
    }

    var condition: String {
        switch self {
        case .black: return "-Black"
        case .white: return "-White"
        }
    }
}

private enum IconType: Int, CaseIterable {
    case wings
    case wing
    case heartWings
    var image: UIImage {
        switch self {
        case .wing: return Asset.wing.image
        case .wings: return Asset.wings.image
        case .heartWings: return Asset.heartWings.image
        }
    }

    var condition: String {
        switch self {
        case .wing: return "-Wing-"
        case .wings: return "-Wings-"
        case .heartWings: return "-Heart-"
        }
    }
}

private enum SectionType: Int, CaseIterable {
    case simple
    case mixed
    var title: String {
        switch self {
        case .simple: return L10n.simple
        case .mixed: return L10n.mixed
        }
    }
}

final class AppIconViewController: UIViewController {

    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var iconBackgroundColorSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var iconTypeSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var separatorView: UIView!

    private var isSameBackground: (String) -> Bool {
        let iconBackgroundIndex = iconBackgroundColorSegmentedControl.selectedSegmentIndex
        let iconBackground = IconBackground(rawValue: iconBackgroundIndex) ?? .white
        return { $0.contains(iconBackground.condition) }
    }

    private var isSameIconType: (String) -> Bool {
        let iconTypeIndex = iconTypeSegmentedControl.selectedSegmentIndex
        let iconType = IconType(rawValue: iconTypeIndex) ?? .wing
        return { $0.contains(iconType.condition) }
    }

    private let isMixedColor: (String) -> Bool = { $0.contains("_") }

    private var normalImageAssets: [ImageAsset] {
        Asset.allImages.filter {
            isSameBackground($0.name)
                && isSameIconType($0.name)
                && !isMixedColor($0.name)
        }
    }

    private var mixedImageAssets: [ImageAsset] {
        Asset.allImages.filter {
            isSameBackground($0.name)
                && isSameIconType($0.name)
                && isMixedColor($0.name)
        }
    }

    private let iconBackgroundKey = "iconBackgroundKey"
    private let iconTypeKey = "iconTypeKey"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupIconBackgroundColorSegmentedControl()
        setupIconTypeSegmentedControl()
        setupSubCustomNavigationBar()
        setupCollectionView()
        setupSeparatorView()

    }

}

// MARK: - func
private extension AppIconViewController {

    func changeIcon(name: String) {
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print("DEBUG_PRINT: 失敗 :\(name)", error.localizedDescription)
                return
            }
            print("DEBUG_PRINT: 成功 :\(name)")
        }
    }

    func getSectionType(section: Int) -> SectionType {
        return SectionType(rawValue: section) ?? .simple
    }

}

// MARK: - IBAction func
private extension AppIconViewController {

    @IBAction func iconBackgroundColorSegmentedControlValueDidChanged(_ sender: Any) {
        let index = iconBackgroundColorSegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(index, forKey: iconBackgroundKey)
        collectionView.reloadData()
    }

    @IBAction func iconTypeSegmentedControlValueDidChanged(_ sender: Any) {
        let index = iconTypeSegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(index, forKey: iconTypeKey)
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate
extension AppIconViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch getSectionType(section: indexPath.section) {
        case .simple:
            let name = normalImageAssets[indexPath.item].name
            changeIcon(name: name)
        case .mixed:
            let name = mixedImageAssets[indexPath.item].name
            changeIcon(name: name)
        }

        let index = iconTypeSegmentedControl.selectedSegmentIndex
        let imageName: String = {
            let iconType = IconType(rawValue: index) ?? .wings
            switch iconType {
            case .wing: return Asset.wing.name
            case .wings: return Asset.wings.name
            case .heartWings: return Asset.heartWings.name
            }
        }()
        UserDefaults.standard.set(imageName, forKey: "IconName")
    }

}

// MARK: - UICollectionViewDataSource
extension AppIconViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        view.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = getSectionType(section: indexPath.section).title
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.backgroundColor = .clear
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch getSectionType(section: section) {
        case .simple:
            return normalImageAssets.count
        case .mixed:
            return mixedImageAssets.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: AppIconCollectionViewCell.self,
                                                            indexPath: indexPath)
        switch getSectionType(section: indexPath.section) {
        case .simple:
            let image = normalImageAssets[indexPath.item].image
            cell.configure(image: image)
        case .mixed:
            let image = mixedImageAssets[indexPath.item].image
            cell.configure(image: image)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AppIconCollectionReusableView.identifier,
                for: indexPath
            )
            return view
        }
        return UICollectionReusableView()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppIconViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 28
        let cellSize: CGFloat = collectionView.frame.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }

}

// MARK: - SubCustomNavigationBarDelegate
extension AppIconViewController: SubCustomNavigationBarDelegate {

    func saveButtonDidTapped() {}

    func dismissButtonDidTapped() {
        dismiss(animated: true)
    }

    var navTitle: String {
        return L10n.appIcon
    }

}

// MARK: - setup
private extension AppIconViewController {

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(AppIconCollectionViewCell.self)
        collectionView.register(AppIconCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: AppIconCollectionReusableView.identifier)
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 21 // horizontalSpaceの3/4倍にする
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        collectionView.collectionViewLayout = layout
    }

    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }

    func setupSeparatorView() {
        separatorView.backgroundColor = .separatorColor
    }

    func setupIconBackgroundColorSegmentedControl() {
        let titles = IconBackground.allCases.map { $0.title }
        let index = UserDefaults.standard.integer(forKey: iconBackgroundKey)
        iconBackgroundColorSegmentedControl.create(titles, selectedIndex: index)
    }

    func setupIconTypeSegmentedControl() {
        let images = IconType.allCases.map { $0.image }
        let index = UserDefaults.standard.integer(forKey: iconTypeKey)
        iconTypeSegmentedControl.setImages(images, selectedIndex: index)
    }

}
