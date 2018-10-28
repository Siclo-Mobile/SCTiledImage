//
//  TiledImageScrollView.swift
//  SICLO
//
//  Created by Maxime POUWELS on 13/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

public protocol SCTiledImageScrollViewDelegate: class {
    func tiledImageScrollViewDidScrollOrZoom(_ tiledImageScrollView: SCTiledImageScrollView)
}

public class SCTiledImageScrollView: UIScrollView {
    
    private static let zoomStep: CGFloat = 2
    
    fileprivate var contentView: SCTiledImageContentView?
    fileprivate var currentBounds = CGSize.zero
    public private(set) var doubleTap: UITapGestureRecognizer!
    public private(set) var twoFingersTap: UITapGestureRecognizer!
    private var addedSubviews: [UIView] = []
    
    fileprivate weak var dataSource: SCTiledImageViewDataSource?
    public weak var tiledImageScrollViewDelegate: SCTiledImageScrollViewDelegate?
    
    public var visibleRect: CGRect {
        return convert(bounds, to: contentView)
    }
    public var maxContentOffset: CGPoint {
        guard let imageSize = dataSource?.displayedImageSize else { return CGPoint.zero }
        return CGPoint(x: imageSize.width * self.maximumZoomScale, y: imageSize.height * self.maximumZoomScale)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentSize")
        removeObserver(self, forKeyPath: "bounds")
    }
    
    private func setup() {
        delegate = self
        
        doubleTap = UITapGestureRecognizer(target: self, action:#selector(SCTiledImageScrollView.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        twoFingersTap = UITapGestureRecognizer(target: self, action: #selector(SCTiledImageScrollView.handleTwoFingersTap(_:)))
        twoFingersTap.numberOfTouchesRequired = 2
        addGestureRecognizer(twoFingersTap)
        
        addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    public func set(dataSource: SCTiledImageViewDataSource) {
        var dataSource = dataSource
        if dataSource.rotation != .none {
            dataSource = TiledImageDataSourceRotationDecorator(tiledImageDataSource: dataSource)
        }
        self.dataSource = dataSource
        contentView?.removeFromSuperview()
        
        let tiledImageView = SCTiledImageView()
        tiledImageView.set(dataSource: dataSource)
        contentView = SCTiledImageContentView(tiledImageView: tiledImageView, dataSource: dataSource)
        for subview in addedSubviews {
            contentView!.add(subview)
        }
        addSubview(contentView!)
        
        currentBounds = bounds.size
        contentSize = dataSource.displayedImageSize
        setMaxMinZoomScalesForCurrentBounds()
        setZoomScale(minimumZoomScale, animated: false)
    }
    
    public func add(subview: UIView) {
        contentView?.add(subview)
        addedSubviews.append(subview)
    }
    
    fileprivate func setMaxMinZoomScalesForCurrentBounds() {
        guard let dataSource = dataSource else {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
        let boundsSize = bounds.size
        
        let imageSize = dataSource.displayedImageSize
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        var minScale = min(xScale, yScale)
        let maxScale = max(CGFloat(dataSource.zoomLevels), 3) * 0.6
        
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
        
        if minimumZoomScale > zoomScale {
            setZoomScale(minimumZoomScale, animated: false)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" || keyPath == "bounds" {
            contentSizeOrBoundsDidChange()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func contentSizeOrBoundsDidChange() {
        if currentBounds != bounds.size {
            currentBounds = bounds.size
            setMaxMinZoomScalesForCurrentBounds()
        }
        let topX = max(-(contentSize.width - bounds.width)/2, 0)
        let topY = max(-(contentSize.height - bounds.height)/2, 0)
        contentView?.frame.origin = CGPoint(x: topX, y: topY)
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        if zoomScale >= maximumZoomScale {
            setZoomScale(minimumZoomScale, animated: false)
        } else {
            let tapCenter = gestureRecognizer.location(in: contentView)
            let newScale = min(zoomScale * SCTiledImageScrollView.zoomStep, maximumZoomScale)
            let maxZoomRect = rect(around: tapCenter, atZoomScale: newScale)
            zoom(to: maxZoomRect, animated: false)
        }
    }
    
    fileprivate func rect(around point: CGPoint, atZoomScale zoomScale: CGFloat) -> CGRect {
        let boundsSize = bounds.size
        let scaledBoundsSize = CGSize(width: boundsSize.width / zoomScale, height: boundsSize.height / zoomScale)
        let point = CGRect(x: point.x - scaledBoundsSize.width / 2, y: point.y - scaledBoundsSize.height / 2, width: scaledBoundsSize.width, height: scaledBoundsSize.height)
        return point
    }
    
    @objc func handleTwoFingersTap(_ sender: AnyObject) {
        let newZoomScale: CGFloat
            
        if zoomScale == minimumZoomScale {
            newZoomScale = maximumZoomScale
        } else {
            let nextZoomScale = zoomScale/SCTiledImageScrollView.zoomStep
            newZoomScale = nextZoomScale < minimumZoomScale  ? minimumZoomScale : nextZoomScale
        }
        setZoomScale(newZoomScale, animated: false)
    }
    
    public func getContentView() -> UIView? {
        return contentView
    }
    
}

extension SCTiledImageScrollView: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        tiledImageScrollViewDelegate?.tiledImageScrollViewDidScrollOrZoom(self)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tiledImageScrollViewDelegate?.tiledImageScrollViewDidScrollOrZoom(self)
    }
    
}
