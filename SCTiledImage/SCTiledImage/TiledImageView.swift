//
//  TiledImageView.swift
//  SICLO
//
//  Created by Maxime POUWELS on 13/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

final public class NoFadeTiledLayer: CATiledLayer {
    override public class func fadeDuration() -> CFTimeInterval {
        return 0
    }
}

final class SCTiledImageView: UIView {
    
    override class var layerClass: AnyClass {
        return NoFadeTiledLayer.self
    }
    
    class func cacheKey(forLevel level: Int, col: Int, row: Int) -> String {
        return "\(level)-\(col)-\(row)"
    }
    
    fileprivate var dataSource: SCTiledImageViewDataSource!
    fileprivate let tileCache = NSCache<NSString, SCDrawableTile>()
    
    deinit {
        layer.contents = nil
        layer.delegate = nil
        layer.removeFromSuperlayer()
    }
    
    func set(dataSource: SCTiledImageViewDataSource) {
        backgroundColor = UIColor.clear
        self.dataSource = dataSource
        dataSource.delegate = self
        
        let layer = self.layer as! CATiledLayer
        layer.levelsOfDetail = dataSource.zoomLevels
        layer.levelsOfDetailBias = 0
        var tileSize = dataSource.tileSize
        if tileSize == CGSize.zero {
            tileSize = dataSource.imageSize
        }
        layer.tileSize = tileSize
        
        let imageSize = dataSource.imageSize
        frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let scaleX = context.ctm.a / UIScreen.main.scale
        let scaleY = context.ctm.d / UIScreen.main.scale
        
        let tiledLayer = layer as! CATiledLayer
        
        var tileSize = tiledLayer.tileSize
        tileSize.width = round(tileSize.width/scaleX)
        tileSize.height = round(-tileSize.height/scaleY)
        
        let level = -Int(round(log2(Float(scaleX))))
        
        let firstCol = Int(floor(rect.minX / tileSize.width))
        let lastCol = Int(floor((rect.maxX-1) / tileSize.width))
        let firstRow = Int(floor(rect.minY / tileSize.height))
        let lastRow = Int(floor((rect.maxY-1) / tileSize.height))
        
        var tilesToRequest: [SCTile] = []
        
        for rowInt in firstRow...lastRow {
            let row = CGFloat(rowInt)
            for colInt in firstCol...lastCol {
                let col = CGFloat(colInt)

                let cacheKey = SCTiledImageView.cacheKey(forLevel: level, col: colInt, row: rowInt)
                var missingImageRect: CGRect?
                
                if let cachedDrawableTile = tileCache.object(forKey: cacheKey as NSString) as SCDrawableTile? {
                    if cachedDrawableTile.hasImage() {
                        cachedDrawableTile.draw()
                    } else {
                        missingImageRect = cachedDrawableTile.tileRect
                    }
                } else {
                    let x = tileSize.width * col
                    let y = tileSize.height * row
                    let width = tileSize.width
                    let height = tileSize.height
                    var tileRect = CGRect(x: x, y: y, width: width, height: height)
                    tileRect = bounds.intersection(tileRect)
                    
                    let drawableTile = SCDrawableTile(rect: tileRect)
                    let tile = SCTile(level: level, col: colInt, row: rowInt)
                    
                    if let image = dataSource.getCachedImage(for: tile) {
                        drawableTile.image = image
                        drawableTile.draw()
                    } else {
                        missingImageRect = tileRect
                        tilesToRequest.append(tile)
                    }
                    tileCache.setObject(drawableTile, forKey: cacheKey as NSString, cost: level)
                }
                
                if let unwrappedMissingImageRect = missingImageRect {
                    drawLowerResTileIfAvailableAtHigherLevel(ofLevel: level, col: colInt, row: rowInt, tileSize: tiledLayer.tileSize, tileRect: unwrappedMissingImageRect)
                }
            }
        }
        if tilesToRequest.count > 0 {
            dataSource.requestTiles(tilesToRequest)
        }
    }
    
    fileprivate func drawLowerResTileIfAvailableAtHigherLevel(ofLevel zoomLevel: Int, col: Int, row: Int, tileSize: CGSize, tileRect: CGRect) {
        if zoomLevel+1 > dataSource.zoomLevels-1 {
            return
        }
        
        for level in zoomLevel+1...dataSource.zoomLevels-1 {
            let zoomDifference = level-zoomLevel
            let scaleDifference = zoomDifference * 2
            let zoomCol = col / scaleDifference
            let zoomRow = row / scaleDifference
            
            let cacheKey = SCTiledImageView.cacheKey(forLevel: level, col: zoomCol, row: zoomRow)
            var tileImage: UIImage?
            if let lowerResTile = tileCache.object(forKey: cacheKey as NSString) as SCDrawableTile? {
                tileImage = lowerResTile.image
            } else {
                let tile = SCTile(level: level, col: zoomCol, row: zoomRow)
                tileImage = dataSource.getCachedImage(for: tile)
            }
            
            if let image = tileImage, let cgImage = image.cgImage {
                let cropCol = col % scaleDifference
                let cropRow = row % scaleDifference
                let scaleDifferenceFloat = CGFloat(scaleDifference)
                
                let size = CGSize(width: tileSize.width / scaleDifferenceFloat, height: tileSize.height / scaleDifferenceFloat)
                let cropBounds = CGRect(x: CGFloat(cropCol) * size.width, y: CGFloat(cropRow) * size.height, width: size.width, height: size.height)
                if let resizedImage = cgImage.cropping(to: cropBounds) {
                    UIImage(cgImage: resizedImage).draw(in: tileRect)
                }
                break
            }
        }
    }
    
}

extension SCTiledImageView: SCTiledImageViewDataSourceDelegate {
    
    func didRetrieve(tilesWithImage: [(SCTile, UIImage)]) {
        for (tile, image) in tilesWithImage {
            let cacheKey = SCTiledImageView.cacheKey(forLevel: tile.level, col: tile.col, row: tile.row)
            if let cachedTile = tileCache.object(forKey: cacheKey as NSString) as SCDrawableTile? {
                cachedTile.image = image
                DispatchQueue.main.async { [weak self] in
                    self?.setNeedsDisplay(cachedTile.tileRect)
                }
            }
        }
    }
    
}

