//
//  CustomScrollableGraphView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import ScrollableGraphView

protocol CustomScrollableGraphViewDelegate: AnyObject {
    func value(at index: Int) -> Double
    func label(at index: Int) -> String
    func numberOfPoints() -> Int
}

final class CustomScrollableGraphView: UIView {

    @IBOutlet private weak var graphView: ScrollableGraphView!

    weak var delegate: CustomScrollableGraphViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    private func loadNib() {
        guard let view = UINib(nibName: String(describing: type(of: self)),
                               bundle: nil)
            .instantiate(withOwner: self,
                         options: nil)
            .first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.layer.cornerRadius = 10
        self.addSubview(view)
        createGraphView()
        createReferenceLines()
    }

    func scrollToRight() {
        let offset = CGPoint(x: max(-graphView.contentInset.left,
                                    graphView.contentSize.width
                                        - graphView.frame.width
                                        + graphView.contentInset.right),
                             y: graphView.contentOffset.y)
        graphView.setContentOffset(offset, animated: false)
    }

    func create(color: UIColor, graph: Graph) {
        switch graph.selectedType {
        case .line:
            createLine(color: color,
                       isFilled: graph.line.isFilled,
                       isSmooth: graph.line.isSmooth)
            if graph.line.withDots {
                createDot(color: color,
                          isSquare: graph.dot.isSquare)
            }
        case .bar:
            createBar(color: color,
                      width: CGFloat(graph.bar.width))
        case .dot:
            createDot(color: color,
                      isSquare: graph.dot.isSquare)
        }
    }

}

// MARK: - create func
private extension CustomScrollableGraphView {

    func createGraphView() {
        graphView.dataSource = self
        graphView.rangeMin = 0
        graphView.rangeMax = 24
        graphView.rightmostPointPadding = 20
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.shouldAnimateOnAdapt = false
        graphView.topMargin = 10
        graphView.dataPointSpacing = 30
        graphView.backgroundColor = .clear
    }

    func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = .black
        referenceLines.dataPointLabelColor = .black
        referenceLines.referenceLineLabelColor = .black
        referenceLines.includeMinMax = false
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [Int](0 ... 24).map { Double($0) }
        graphView.addReferenceLines(referenceLines: referenceLines)
    }

    func createLine(color: UIColor, isFilled: Bool, isSmooth: Bool) {
        let linePlot = LinePlot(identifier: "")
        linePlot.lineColor = color
        linePlot.animationDuration = 0.1
        linePlot.adaptAnimationType = .easeOut
        if isFilled {
            linePlot.shouldFill = true
            linePlot.fillType = .gradient
            linePlot.fillColor = color
            linePlot.fillGradientType = .linear
            linePlot.fillGradientStartColor = color
            linePlot.fillGradientEndColor = .white
        }
        if isSmooth {
            linePlot.lineStyle = .smooth
        } else {
            linePlot.lineStyle = .straight
        }
        graphView.addPlot(plot: linePlot)
    }

    func createDot(color: UIColor, isSquare: Bool) {
        let dotPlot = DotPlot(identifier: "")
        dotPlot.dataPointType = .circle
        dotPlot.animationDuration = 0.1
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        if isSquare {
            dotPlot.dataPointType = .square
        } else {
            dotPlot.dataPointType = .circle
        }
        graphView.addPlot(plot: dotPlot)
    }

    func createBar(color: UIColor, width: CGFloat) {
        let barPlot = BarPlot(identifier: "")
        barPlot.animationDuration = 0.1
        barPlot.adaptAnimationType = .easeOut
        barPlot.barWidth = width
        barPlot.barLineWidth = 3
        barPlot.barColor = color
        barPlot.barLineColor = color.withAlphaComponent(0.6)
        graphView.addPlot(plot: barPlot)
    }

}

// MARK: - ScrollableGraphViewDataSource
extension CustomScrollableGraphView: ScrollableGraphViewDataSource {

    func value(forPlot plot: Plot,
               atIndex pointIndex: Int) -> Double {
        return delegate.value(at: pointIndex)
    }

    func label(atIndex pointIndex: Int) -> String {
        return delegate.label(at: pointIndex)
    }

    func numberOfPoints() -> Int {
        return delegate.numberOfPoints()
    }

}
