//
//  WaveView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/19.
//

import UIKit

final class WaveView: UIView {
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var middleView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = UINib(
            nibName: String(describing: type(of: self)),
            bundle: nil
        ).instantiate(
            withOwner: self,
            options: nil
        ).first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
        
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        middleView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
    }
    
    func create(isFill: Bool, marginY: CGFloat, isShuffled: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.cutToWaveView(isFill: isFill, marginY: marginY, isShuffled: isShuffled)
        }
    }
    
    private func cutToWaveView(isFill: Bool, marginY: CGFloat, isShuffled: Bool) {
        let alpha: CGFloat = 0.5
        let alphaMargin: CGFloat = 0.2
        let maths: [Math] = isShuffled ? Math.random() : [.plusSin, .plusCos, .minusCos]
        let topInfo = WaveViewInfo(waveCount: 1,
                                   amplitude: 1,
                                   gradient: Gradient(leftColor: .black.withAlphaComponent(alpha - alphaMargin),
                                                      rightColor: .white.withAlphaComponent(alpha - alphaMargin)),
                                   math: maths[0],
                                   marginY: marginY,
                                   isFill: isFill)
        topView.cutView(info: topInfo)
        let middleInfo = WaveViewInfo(waveCount: 1.5,
                                      amplitude: 1.3,
                                      gradient: Gradient(leftColor: .black.withAlphaComponent(alpha),
                                                         rightColor: .white.withAlphaComponent(alpha)),
                                      math: maths[1],
                                      marginY: marginY,
                                      isFill: isFill)
        middleView.cutView(info: middleInfo)
        let bottomInfo = WaveViewInfo(waveCount: 1,
                                      amplitude: 1.5,
                                      gradient: Gradient(leftColor: .black.withAlphaComponent(alpha + alphaMargin),
                                                         rightColor: .white.withAlphaComponent(alpha + alphaMargin)),
                                      math: maths[2],
                                      marginY: marginY,
                                      isFill: isFill)
        bottomView.cutView(info: bottomInfo)
    }
    
}

struct WaveViewInfo {
    let waveCount: Double
    let amplitude: Double
    let gradient: Gradient
    let math: Math
    let marginY: CGFloat
    let isFill: Bool
}

struct Gradient {
    let leftColor: UIColor
    let rightColor: UIColor
}

enum Math: CaseIterable {
    case minusSin
    case minusCos
    case plusSin
    case plusCos
    
    func trigonometricFunc(_ x: Double) -> Double {
        switch self {
            case .minusSin: return -sin(x)
            case .minusCos: return -cos(x)
            case .plusSin: return sin(x)
            case .plusCos: return cos(x)
        }
    }
    
    static func random() -> [Self] {
        return Math.allCases.shuffled()
    }
}

private extension UIView {
    
    func cutView(info: WaveViewInfo) {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: self.frame.width,
                             height: self.frame.height)
        let fillColor: UIColor = info.isFill ? info.gradient.leftColor : .clear
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = info.gradient.leftColor.cgColor
        layer.lineWidth = 3
        layer.path = createPath(layer: layer, info: info)
        if let layer = self.layer.sublayers?.first {
            layer.removeFromSuperlayer()
        }
        self.layer.addSublayer(layer)
        
        self.setGradation(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.frame.width,
                                        height: self.frame.height + info.marginY),
                          colors: [.black, .white],
                          startPoint: (x: 0, y: 0.5),
                          endPoint: (x: 1, y: 0.5),
                          locations: [0, 0.9],
                          masksToBounds: false,
                          layer: layer)
        
        self.setShadow(radius: 20, size: (width: 3, height: 3))
    }
    
    private func createPath(layer: CAShapeLayer, info: WaveViewInfo) -> CGPath {
        let div: Double = 1 / 100
        let path = UIBezierPath()
        let originX: CGFloat = layer.lineWidth
        let origin = CGPoint(x: -originX,
                             y: layer.frame.height / 2 + info.marginY)
        let count = info.waveCount * 2
        let xRatioToFill = Double(layer.frame.width) / (Double.pi / div)
        path.move(to: CGPoint(x: origin.x, y: 0))
        path.addLine(to: CGPoint(x: origin.x, y: origin.y))
        for i in 0...Int(Double.pi / div * count) {
            let x = div * Double(i)
            let y = info.math.trigonometricFunc(x)
            path.addLine(
                to: CGPoint(x: (x / div / count + Double(origin.x)) * xRatioToFill + Double(originX * 2),
                            y: Double(origin.y) * (1 - y * info.amplitude / 10))
            )
        }
        path.addLine(to: CGPoint(x: layer.frame.width + originX, y: 0))
        return path.cgPath
    }
    
}
