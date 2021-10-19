//
//  AppIconViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

private enum IconBackground: CaseIterable {
    case black
    case white
    var title: String {
        switch self {
            case .black: return L10n.black
            case .white: return L10n.white
        }
    }
}

private enum IconType: CaseIterable {
    case wing
    case wings
    case heartWings
    var image: UIImage {
        switch self {
            case .wing: return Asset.wing.image
            case .wings: return Asset.wings.image
            case .heartWings: return Asset.heartWings.image
        }
    }
}

final class AppIconViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var iconBackgroundColorSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var iconTypeSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var separatorView: UIView!
    
    private let imageAssets = Asset.allImages
    private let iconBackgroundKey = "iconBackgroundKey"
    private let iconTypeKey = "iconTypeKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubCustomNavigationBar()
        setupCollectionView()
        setupSeparatorView()
        setupIconBackgroundColorSegmentedControl()
        setupIconTypeSegmentedControl()
        
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
        collectionView.deselectItem(at: indexPath, animated: true)
        let name = Asset.allImages[indexPath.item].name
        changeIcon(name: name)
    }
    
}

// MARK: - UICollectionViewDataSource
extension AppIconViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: AppIconCollectionViewCell.self,
                                                            indexPath: indexPath)
        let image = imageAssets[indexPath.item].image
        cell.configure(image: image)
        return cell
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
    
    func saveButtonDidTapped() { }
    
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
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 21
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
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
