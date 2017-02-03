//
//  TiledImageContentView.swift
//  TileViewTest
//
//  Created by Maxime POUWELS on 14/09/16.
//  Copyright © 2016 siclo. All rights reserved.
//

import UIKit

class SCTiledImageContentView: UIView {
    
    private let tiledImageView: SCTiledImageView
    private let backgroundImageView: UIImageView
    
    init(tiledImageView: SCTiledImageView, dataSource: SCTiledImageViewDataSource) {
        self.tiledImageView = tiledImageView
        self.backgroundImageView = UIImageView(frame: tiledImageView.bounds)
        super.init(frame: tiledImageView.frame)
        
        backgroundImageView.contentMode = .scaleAspectFit
        dataSource.requestBackgroundImage { [weak self] image in
            self?.backgroundImageView.image = image
        }
        addSubview(backgroundImageView)
        addSubview(tiledImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(_ view: UIView) {
        view.frame = tiledImageView.bounds
        addSubview(view)
    }
    
}
