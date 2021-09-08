//
//  ScrollableGraphView.swift
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
    
    private var graphView: ScrollableGraphView!
    weak var delegate: CustomScrollableGraphViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGraphView()
        createReferenceLines()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        createGraphView()
        createReferenceLines()
        
    }
    
    func set(to view: UIView) {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.frame.width,
                           height: self.frame.height)
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.rangeMin = 0
        graphView.rangeMax = 24
        graphView.rightmostPointPadding = 20
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.topMargin = 10
        graphView.dataPointSpacing = 30
    }
    
    func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = .black
        referenceLines.includeMinMax = false
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [Int](0...24).map { Double($0) }
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    
    func createLine(color: UIColor, isFilled: Bool, isSmooth: Bool) {
        let linePlot = LinePlot(identifier: "")
        linePlot.lineColor = color
        linePlot.adaptAnimationType = .easeOut
        linePlot.animationDuration = 0.1
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
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.animationDuration = 0.1
        if isSquare {
            dotPlot.dataPointType = .square
        } else {
            dotPlot.dataPointType = .circle
        }
        graphView.addPlot(plot: dotPlot)
    }
    
    func createBar(color: UIColor, width: CGFloat) {
        let barPlot = BarPlot(identifier: "")
        barPlot.adaptAnimationType = .easeOut
        barPlot.animationDuration = 0.3
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
