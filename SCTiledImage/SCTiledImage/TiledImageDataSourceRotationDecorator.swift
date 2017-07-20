//
//  TiledImageDataSourceRotationAdapter.swift
//  SCTiledImage
//
//  Created by Maxime POUWELS on 18/07/2017.
//

class TiledImageDataSourceRotationDecorator: SCTiledImageViewDataSource {
    
    private let tiledImageDataSource: SCTiledImageViewDataSource
    let rotation: SCTiledImageRotation
    
    weak var delegate: SCTiledImageViewDataSourceDelegate? {
        didSet {
            tiledImageDataSource.delegate = self
        }
    }
    
    var imageSize: CGSize {
        return tiledImageDataSource.imageSize
    }
    
    var tileSize: CGSize {
        return tiledImageDataSource.tileSize
    }
    
    var zoomLevels: Int {
        return tiledImageDataSource.zoomLevels
    }
    
    init(tiledImageDataSource: SCTiledImageViewDataSource) {
        self.tiledImageDataSource = tiledImageDataSource
        self.rotation = tiledImageDataSource.rotation
    }
    
    func requestTiles(_ tiles: [SCTile]) {
        tiledImageDataSource.requestTiles(tiles)
    }
    
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ()) {
        tiledImageDataSource.requestBackgroundImage() { [weak self] image in
            guard let`self` = self, let image = image else {
                completionHandler(nil)
                return
            }
            let rotatedImage: UIImage = {
                if self.rotation == .none {
                    return image
                }
                let angle = self.rotation.angleInRadians
                return image.rotated(angleInRadians: CGFloat(angle)) ?? image
            }()
            completionHandler(rotatedImage)
        }
    }
    
    func getCachedImage(for tile: SCTile) -> UIImage? {
        if rotation == .none {
            return tiledImageDataSource.getCachedImage(for: tile)
        }
        
        let angle = CGFloat(rotation.angleInRadians)
        return tiledImageDataSource.getCachedImage(for: tile)?.rotated(angleInRadians: angle)
    }
    
}

extension TiledImageDataSourceRotationDecorator: SCTiledImageViewDataSourceDelegate {
    func didRetrieve(tilesWithImage: [(SCTile, UIImage)]) {
        if rotation == .none {
            delegate?.didRetrieve(tilesWithImage: tilesWithImage)
        } else {
            let angle = CGFloat(rotation.angleInRadians)
            let rotatedTilesWithImage: [(SCTile, UIImage)] = tilesWithImage.map { (tile, image) in
                let rotatedImage = image.rotated(angleInRadians: angle) ?? image
                return (tile, rotatedImage)
            }
            delegate?.didRetrieve(tilesWithImage: rotatedTilesWithImage)
        }
    }
}
