//
//  TiledImageDataSource.swift
//  APROPLAN
//
//  Created by Maxime POUWELS on 15/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

public struct SCTile {
    let level: Int
    let col: Int
    let row: Int
}

public protocol SCTiledImageViewDataSource: class {
    var delegate: SCTiledImageViewDataSourceDelegate? { get set }
    var imageSize: CGSize { get }
    var tileSize: CGSize { get }
    var zoomLevels: Int { get }
    func requestTiles(_ tiles: [SCTile])
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ())
    func getCachedImage(for tile: SCTile) -> UIImage?
}

public protocol SCTiledImageViewDataSourceDelegate: class {
    func didRetrieve(tilesWithImage: [(SCTile, UIImage)])
}
