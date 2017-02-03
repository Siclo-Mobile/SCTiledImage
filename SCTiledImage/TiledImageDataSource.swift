//
//  TiledImageDataSource.swift
//  APROPLAN
//
//  Created by Maxime POUWELS on 15/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

public struct Tile {
    let level: Int
    let col: Int
    let row: Int
}

public protocol TiledImageViewDataSource: class {
    var delegate: TiledImageViewDataSourceDelegate? { get set }
    var imageSize: CGSize { get }
    var tileSize: CGSize { get }
    var zoomLevels: Int { get }
    func requestTiles(_ tiles: [Tile])
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ())
    func getCachedImage(for tile: Tile) -> UIImage?
}

public protocol TiledImageViewDataSourceDelegate: class {
    func didRetrieve(tilesWithImage: [(Tile, UIImage)])
}
