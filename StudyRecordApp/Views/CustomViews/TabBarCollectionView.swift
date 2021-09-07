//
//  TabBarCollectionView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/07.
//

import UIKit

protocol TabBarCollectionViewDelegate: AnyObject {
    func collectionViewDidTapped(index: Int)
}

final class TabBarCollectionView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: TabBarCollectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setupCollectionView()
    }
    
    func scroll(at item: Int) {
        collectionView.scrollToItem(at: IndexPath(item: item,
                                                  section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
}

// MARK: - func
private extension TabBarCollectionView {
    
    func loadNib() {
        guard let view = UINib(nibName: String(describing: type(of: self)),
                               bundle: nil)
                .instantiate(withOwner: self,
                             options: nil)
                .first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}

// MARK: - UICollectionViewDelegate
extension TabBarCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewDidTapped(index: indexPath.item)
    }
    
}

// MARK: - UICollectionViewDataSource
extension TabBarCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return ScreenType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: ScreenTransitionCollectionViewCell.self,
                                                            indexPath: indexPath)
        let screenType = ScreenType.allCases[indexPath.row]
        cell.configure(title: screenType.title)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TabBarCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 15
        let verticalSpace: CGFloat = 15
        print(collectionView.frame.width) // 921
        print(UIScreen.main.bounds.width) // 390
        let width = collectionView.frame.size.width / 2 - horizontalSpace * 2
        let height = collectionView.frame.size.height - verticalSpace * 2
        print(width) // 430
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}
// MARK: - setup
private extension TabBarCollectionView {
    
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
    
}
