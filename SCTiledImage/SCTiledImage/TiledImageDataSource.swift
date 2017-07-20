//
//  TiledImageDataSource.swift
//  SICLO
//
//  Created by Maxime POUWELS on 15/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

public struct SCTile {
    public let level: Int
    public let col: Int
    public let row: Int
    
    public init(level: Int, col: Int, row: Int) {
        self.level = level
        self.col = col
        self.row = row
    }
}

public protocol SCTiledImageViewDataSource: class {
    var delegate: SCTiledImageViewDataSourceDelegate? { get set }
    var imageSize: CGSize { get }
    var tileSize: CGSize { get }
    var zoomLevels: Int { get }
    var rotation: SCTiledImageRotation { get }
    func requestTiles(_ tiles: [SCTile])
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ())
    func getCachedImage(for tile: SCTile) -> UIImage?
}

public extension SCTiledImageViewDataSource {
    var rotation: SCTiledImageRotation {
        return .none
    }
    
    var displayedImageSize: CGSize {
        switch rotation {
        case .none, .half:
            return imageSize
        case .right, .left:
            return CGSize(width: imageSize.height, height: imageSize.width)
        }
    }

}

public protocol SCTiledImageViewDataSourceDelegate: class {
    func didRetrieve(tilesWithImage: [(SCTile, UIImage)])
}
