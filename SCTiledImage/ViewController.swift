//
//  ViewController.swift
//  SCTiledImage
//
//  Created by Maxime POUWELS on 03/02/2017.
//  Copyright © 2017 siclo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tiledImageScrollView: SCTiledImageScrollView!
    private var dataSource: ExampleTiledImageDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTiledImageScrollView()
    }
    
    private func setupTiledImageScrollView() {
        let imageSize = CGSize(width: 9112, height: 4677)
        let tileSize = CGSize(width: 256, height: 256)
        let zoomLevels = 4
        
        dataSource = ExampleTiledImageDataSource(imageSize: imageSize, tileSize: tileSize, zoomLevels: zoomLevels)
        tiledImageScrollView.set(dataSource: dataSource!)
    }
    
}
