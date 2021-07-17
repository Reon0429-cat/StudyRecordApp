//
//  ColorChoicesSliderViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/30.
//

import UIKit

protocol ColorChoicesSliderVCDelegate: AnyObject {
    func sliderValueDidChanged(view: UIView)
}

final class ColorChoicesSliderViewController: UIViewController {
    
    @IBOutlet private weak var redNumberLabel: UILabel!
    @IBOutlet private weak var greenNumberLabel: UILabel!
    @IBOutlet private weak var blueNumberLabel: UILabel!
    @IBOutlet private weak var alphaNumberLabel: UILabel!
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var alphaSlider: UISlider!
    
    weak var delegate: ColorChoicesSliderVCDelegate?
    private var sliderView: UIView!
    private struct RGBA {
        var red, green, blue, alpha: CGFloat
    }
    private var rgba: RGBA!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustSliders),
                                               name: .themeColor,
                                               object: nil)
        
    }
    
    @objc private func adjustSliders(notification: Notification) {
        let nextSelectedView = notification.userInfo!["selectedView"] as! UIView
        let redValue = round(nextSelectedView.backgroundColor!.redValue * 255)
        let greenValue = round(nextSelectedView.backgroundColor!.greenValue * 255)
        let blueValue = round(nextSelectedView.backgroundColor!.blueValue * 255)
        let alphaValue = (round(nextSelectedView.backgroundColor!.alphaValue * 10) / 10) * 100
        rgba = RGBA(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        sliderView = UIView()
        redNumberLabel.text = String(Int(redValue))
        greenNumberLabel.text = String(Int(greenValue))
        blueNumberLabel.text = String(Int(blueValue))
        alphaNumberLabel.text = String(Int(alphaValue))
        redSlider.value = Float(redValue)
        greenSlider.value = Float(greenValue)
        blueSlider.value = Float(blueValue)
        alphaSlider.value = Float(alphaValue)
    }
    
    @IBAction private func redSliderValueDidChanged(_ sender: UISlider) {
        let redValue = CGFloat(sender.value)
        sliderView.backgroundColor = UIColor.rgba(red: redValue, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
        delegate?.sliderValueDidChanged(view: sliderView)
        NotificationCenter.default.post(name: .initTileView, object: nil)
        redNumberLabel.text = String(Int(sender.value))
    }
    
    @IBAction private func greenSliderValueDidChanged(_ sender: UISlider) {
        let greenValue = CGFloat(sender.value)
        sliderView.backgroundColor = UIColor.rgba(red: rgba.red, green: greenValue, blue: rgba.blue, alpha: rgba.alpha)
        delegate?.sliderValueDidChanged(view: sliderView)
        NotificationCenter.default.post(name: .initTileView, object: nil)
        greenNumberLabel.text = String(Int(sender.value))
    }
    
    @IBAction private func blueSliderValueDidChanged(_ sender: UISlider) {
        let blueValue = CGFloat(sender.value)
        sliderView.backgroundColor = UIColor.rgba(red: rgba.red, green: rgba.green, blue: blueValue, alpha: rgba.alpha)
        delegate?.sliderValueDidChanged(view: sliderView)
        NotificationCenter.default.post(name: .initTileView, object: nil)
        blueNumberLabel.text = String(Int(sender.value))
    }
    
    @IBAction private func alphaSliderValueDidChanged(_ sender: UISlider) {
        let alphaValue = CGFloat(sender.value)
        sliderView.backgroundColor = UIColor.rgba(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alphaValue)
        delegate?.sliderValueDidChanged(view: sliderView)
        NotificationCenter.default.post(name: .initTileView, object: nil)
        alphaNumberLabel.text = String(Int(sender.value))
    }
    
}
