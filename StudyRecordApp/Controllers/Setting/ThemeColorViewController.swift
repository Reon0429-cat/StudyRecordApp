//
//  ThemeColorViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

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

protocol ThemeColorViewDelegate: AnyObject {
    func themeColorViewDidTapped(nextSelectedView: UIView)
}

final class ThemeColorView: UIView {
    
    weak var delegate: ThemeColorViewDelegate?
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eyedropper")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.themeColorViewDidTapped(nextSelectedView: self)
    }
    
    func hideImage(_ isHidden: Bool) {
        imageView.isHidden = isHidden
    }
    
}

final class ThemeColorViewController: UIViewController {
    
    @IBOutlet private weak var mainColorView: ThemeColorView!
    @IBOutlet private weak var subColorView: ThemeColorView!
    @IBOutlet private weak var accentColorView: ThemeColorView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var segmentedControlBackView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var colorChoicesConceptContainerView: UIView!
    @IBOutlet private weak var colorChoicesTileContainerView: UIView!
    @IBOutlet private weak var colorChoicesSliderContainerView: UIView!
    
    private var containerType: ContainerType = .tile
    private var currentContainerView: UIView {
        switch containerType {
            case .concept: return colorChoicesConceptContainerView
            case .tile: return colorChoicesTileContainerView
            case .slider: return colorChoicesSliderContainerView
        }
    }
    private var navTitle = ""
    private var colorConcept: ColorConcept?
    private var lastSelectedThemeColorView: ThemeColorView?
    private var scheme: ColorSchemeType = .main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.bringSubviewToFront(currentContainerView)
        self.navigationItem.title = navTitle
        setupThemeColorView()
        setupSegmentedControl()
        setupContainerViewControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupThemeColorViewColor()
        NotificationCenter.default.post(name: .themeColor,
                                        object: nil,
                                        userInfo: ["selectedView": mainColorView!])
        
    }
    
    private func setupContainerViewControllers() {
        let colorChoicesConceptVC = children[ContainerType.concept.rawValue] as! ColorChoicesConceptViewController
        colorChoicesConceptVC.delegate = self
        colorChoicesConceptVC.colorConcept = colorConcept
        
        let colorChoicesTileVC = children[ContainerType.tile.rawValue] as! ColorChoicesTileViewController
        colorChoicesTileVC.delegate = self
        
        let colorChoicesSliderVC = children[ContainerType.slider.rawValue] as! ColorChoicesSliderViewController
        colorChoicesSliderVC.delegate = self
    }
    
    private func setupThemeColorView() {
        mainColorView.delegate = self
        subColorView.delegate = self
        accentColorView.delegate = self
        if containerType == .concept {
            mainColorView.isUserInteractionEnabled = false
            subColorView.isUserInteractionEnabled = false
            accentColorView.isUserInteractionEnabled = false
        }
        setupImageView(view: mainColorView)
        setupImageView(view: subColorView)
        setupImageView(view: accentColorView)
        mainColorView.hideImage(false)
        lastSelectedThemeColorView = mainColorView
    }
    
    private func setupSegmentedControl() {
        if containerType == .concept {
            segmentedControlBackView.isHidden = true
        }
    }
    
    private func setupThemeColorViewColor() {
        mainColorView.backgroundColor = ThemeColor.main
        subColorView.backgroundColor = ThemeColor.sub
        accentColorView.backgroundColor = ThemeColor.accent
        setThemeSubViewColor(view: mainColorView)
        setThemeSubViewColor(view: subColorView)
        setThemeSubViewColor(view: accentColorView)
    }
    
    private func setupImageView(view: ThemeColorView) {
        view.addSubview(view.imageView)
        NSLayoutConstraint.activate([
            view.imageView.heightAnchor.constraint(equalToConstant: 40),
            view.imageView.widthAnchor.constraint(equalToConstant: 40),
            view.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        view.imageView.isHidden = true
    }
    
    private func setThemeSubViewColor(view: ThemeColorView?) {
        guard let color = view?.backgroundColor else { fatalError() }
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
    
    @IBAction private func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        // enum ContainerTypeにあわせるために+1する。
        containerType = ContainerType(rawValue: sender.selectedSegmentIndex + 1)!
        if containerType == .slider {
            NotificationCenter.default.post(name: .themeColor,
                                            object: nil,
                                            userInfo: ["selectedView": lastSelectedThemeColorView!])
        }
        containerView.bringSubviewToFront(currentContainerView)
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        UserDefaults.standard.save(color: mainColorView.backgroundColor, .main)
        UserDefaults.standard.save(color: subColorView.backgroundColor, .sub)
        UserDefaults.standard.save(color: accentColorView.backgroundColor, .accent)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    static func instantiate(containerType: ContainerType,
                            colorConcept: ColorConcept?) -> ThemeColorViewController {
        let themeColorVC = UIStoryboard(
            name: "ThemeColor",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: self)
        ) as! ThemeColorViewController
        themeColorVC.containerType = containerType
        let navTitle = colorConcept?.title ?? "セルフ"
        themeColorVC.navTitle = navTitle
        themeColorVC.colorConcept = colorConcept
        return themeColorVC
    }
    
}

extension ThemeColorViewController: ColorChoicesTileVCDelegate {
    
    func tileViewDidTapped(selectedView: UIView) {
        lastSelectedThemeColorView?.backgroundColor = selectedView.backgroundColor
        lastSelectedThemeColorView?.alpha = selectedView.alpha
        setThemeSubViewColor(view: lastSelectedThemeColorView)
    }
    
}

extension ThemeColorViewController: ColorChoicesSliderVCDelegate {
    
    func sliderValueDidChanged(view: UIView) {
        lastSelectedThemeColorView?.backgroundColor = view.backgroundColor
        lastSelectedThemeColorView?.alpha = view.alpha
        setThemeSubViewColor(view: lastSelectedThemeColorView)
    }
    
}

extension ThemeColorViewController: ColorChoicesConceptVCDelegate {
    
    func subConceptTileViewDidTapped(view: UIView) {
        lastSelectedThemeColorView?.backgroundColor = view.backgroundColor
        lastSelectedThemeColorView?.alpha = view.alpha
        mainColorView.hideImage(true)
        subColorView.hideImage({ scheme != .main }())
        accentColorView.hideImage({ scheme != .sub }())
        switchTheme(scheme: scheme)
    }
    
    func subConceptTitleDidTapped(isExpanded: Bool) {
        mainColorView.hideImage(!isExpanded)
        subColorView.hideImage(true)
        accentColorView.hideImage(true)
        switchTheme()
    }
    
    private func switchTheme(scheme: ColorSchemeType? = nil) {
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
    
}

extension ThemeColorViewController: ThemeColorViewDelegate {
    
    func themeColorViewDidTapped(nextSelectedView: UIView) {
        let isSameViewDidTapped = (lastSelectedThemeColorView == nextSelectedView)
        let _nextSelectedView = (nextSelectedView as! ThemeColorView)
        if !isSameViewDidTapped {
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
