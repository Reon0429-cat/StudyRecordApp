//
//  ThemeColorViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

final class ThemeColorViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var mainColorView: ThemeColorView!
    @IBOutlet private weak var subColorView: ThemeColorView!
    @IBOutlet private weak var accentColorView: ThemeColorView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var segmentedControlBackView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var colorChoicesConceptContainerView: UIView!
    @IBOutlet private weak var colorChoicesTileContainerView: UIView!
    @IBOutlet private weak var colorChoicesSliderContainerView: UIView!
    
    enum ContainerType: Int {
        case concept
        case tile
        case slider
    }
    enum ColorSchemeType {
        case main
        case sub
        case accent
    }
    var containerType: ContainerType = .tile
    var colorConcept: ColorConcept?
    var navigationTitle = ""
    private var currentContainerView: UIView {
        switch containerType {
            case .concept: return colorChoicesConceptContainerView
            case .tile: return colorChoicesTileContainerView
            case .slider: return colorChoicesSliderContainerView
        }
    }
    private var lastSelectedThemeColorView: ThemeColorView?
    private var scheme: ColorSchemeType = .main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.bringSubviewToFront(currentContainerView)
        setupThemeColorViews()
        setupSegmentedControl()
        setupContainerViewControllers()
        setupSubCustomNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupThemeColorViewColor()
        NotificationCenter.default.post(name: .themeColor,
                                        object: nil,
                                        userInfo: ["selectedView": mainColorView!])
        
    }
    
}

// MARK: - IBAction func
private extension ThemeColorViewController {
    
    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        // enum ContainerTypeにあわせるために+1する。
        containerType = ContainerType(rawValue: sender.selectedSegmentIndex + 1)!
        if containerType == .slider {
            NotificationCenter.default.post(name: .themeColor,
                                            object: nil,
                                            userInfo: ["selectedView": lastSelectedThemeColorView!])
        }
        containerView.bringSubviewToFront(currentContainerView)
    }
    
}

// MARK: - func
private extension ThemeColorViewController {
    
    func switchTheme(scheme: ColorSchemeType? = nil) {
        if lastSelectedThemeColorView != nil {
            setThemeSubViewColor(view: lastSelectedThemeColorView)
        }
        switch scheme {
            case .main:
                lastSelectedThemeColorView = subColorView
                self.scheme = .sub
            case .sub:
                lastSelectedThemeColorView = accentColorView
                self.scheme = .accent
            case .accent:
                lastSelectedThemeColorView = nil
            case nil:
                lastSelectedThemeColorView = mainColorView
                self.scheme = .main
        }
    }
    
    func setThemeSubViewColor(view: ThemeColorView?) {
        guard let color = view?.backgroundColor else { return }
        view?.subviews.forEach { view in
            let shouldWhite = (color.redValue < 0.4
                                && color.greenValue < 0.4
                                && color.blueValue < 0.4
                                && color.alphaValue > 0.5)
            if let imageView = view as? UIImageView {
                imageView.tintColor = { shouldWhite ? .white : .black }()
            }
            if let label = view as? UILabel {
                label.textColor = { shouldWhite ? .white : .black }()
            }
        }
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension ThemeColorViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() {
        UserDefaults.standard.save(color: mainColorView.backgroundColor, .main)
        UserDefaults.standard.save(color: subColorView.backgroundColor, .sub)
        UserDefaults.standard.save(color: accentColorView.backgroundColor, .accent)
        if containerType == .concept {
            presentingViewController?.presentingViewController?.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    func dismissButtonDidTapped() {
        dismiss(animated: true)
    }
    
    var navTitle: String {
        return navigationTitle
    }
    
}

// MARK: - ColorChoicesTileVCDelegate
extension ThemeColorViewController: ColorChoicesTileVCDelegate {
    
    func tileViewDidTapped(selectedView: UIView,
                           isSameView: Bool) {
        let isWhite = lastSelectedThemeColorView?.backgroundColor == .white
        if isSameView && !isWhite {
            lastSelectedThemeColorView?.backgroundColor = .white
        } else {
            lastSelectedThemeColorView?.backgroundColor = selectedView.backgroundColor
            lastSelectedThemeColorView?.alpha = selectedView.alpha
        }
        setThemeSubViewColor(view: lastSelectedThemeColorView)
    }
    
}

// MARK: - ColorChoicesSliderVCDelegate
extension ThemeColorViewController: ColorChoicesSliderVCDelegate {
    
    func sliderValueDidChanged(view: UIView) {
        lastSelectedThemeColorView?.backgroundColor = view.backgroundColor
        lastSelectedThemeColorView?.alpha = view.alpha
        setThemeSubViewColor(view: lastSelectedThemeColorView)
    }
    
}

// MARK: - ColorChoicesConceptVCDelegate
extension ThemeColorViewController: ColorChoicesConceptVCDelegate {
    
    func subConceptTileViewDidTapped(view: UIView) {
        lastSelectedThemeColorView?.backgroundColor = view.backgroundColor
        lastSelectedThemeColorView?.alpha = view.alpha
        mainColorView.hideImage(true)
        subColorView.hideImage(scheme != .main)
        accentColorView.hideImage(scheme != .sub)
        switchTheme(scheme: scheme)
    }
    
    func subConceptTitleDidTapped(isExpanded: Bool) {
        mainColorView.hideImage(!isExpanded)
        subColorView.hideImage(true)
        accentColorView.hideImage(true)
        switchTheme()
    }
    
}

// MARK: - ThemeColorViewDelegate
extension ThemeColorViewController: ThemeColorViewDelegate {
    
    func themeColorViewDidTapped(nextSelectedView: UIView) {
        let isSameView = (lastSelectedThemeColorView == nextSelectedView)
        let _nextSelectedView = (nextSelectedView as! ThemeColorView)
        if !isSameView {
            _nextSelectedView.hideImage(false)
            lastSelectedThemeColorView?.hideImage(true)
            NotificationCenter.default.post(name: .themeColor,
                                            object: nil,
                                            userInfo: ["selectedView": nextSelectedView])
        }
        setThemeSubViewColor(view: lastSelectedThemeColorView)
        lastSelectedThemeColorView = _nextSelectedView
    }
    
}

// MARK: - setup
private extension ThemeColorViewController {
    
    func setupContainerViewControllers() {
        let colorChoicesConceptVC = children[ContainerType.concept.rawValue] as! ColorChoicesConceptViewController
        colorChoicesConceptVC.delegate = self
        colorChoicesConceptVC.colorConcept = colorConcept
        
        let colorChoicesTileVC = children[ContainerType.tile.rawValue] as! ColorChoicesTileViewController
        colorChoicesTileVC.delegate = self
        
        let colorChoicesSliderVC = children[ContainerType.slider.rawValue] as! ColorChoicesSliderViewController
        colorChoicesSliderVC.delegate = self
    }
    
    func setupThemeColorViews() {
        mainColorView.delegate = self
        subColorView.delegate = self
        accentColorView.delegate = self
        if containerType == .concept {
            mainColorView.isUserInteractionEnabled = false
            subColorView.isUserInteractionEnabled = false
            accentColorView.isUserInteractionEnabled = false
        }
        setupImageViewLayout(view: mainColorView)
        setupImageViewLayout(view: subColorView)
        setupImageViewLayout(view: accentColorView)
        mainColorView.hideImage(false)
        lastSelectedThemeColorView = mainColorView
    }
    
    func setupSegmentedControl() {
        if containerType == .concept {
            segmentedControlBackView.isHidden = true
        }
    }
    
    func setupThemeColorViewColor() {
        mainColorView.backgroundColor = ThemeColor.main
        subColorView.backgroundColor = ThemeColor.sub
        accentColorView.backgroundColor = ThemeColor.accent
        setThemeSubViewColor(view: mainColorView)
        setThemeSubViewColor(view: subColorView)
        setThemeSubViewColor(view: accentColorView)
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
    }
    
}

// MARK: - setup layout
private extension ThemeColorViewController {
    
    func setupImageViewLayout(view: ThemeColorView) {
        view.addSubview(view.imageView)
        NSLayoutConstraint.activate([
            view.imageView.heightAnchor.constraint(equalToConstant: 40),
            view.imageView.widthAnchor.constraint(equalToConstant: 40),
            view.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.imageView.isHidden = true
    }
    
}
