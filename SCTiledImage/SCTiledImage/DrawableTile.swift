//
//  DrawableTile.swift
//  APROPLAN
//
//  Created by Maxime POUWELS on 13/09/16.
//  Copyright © 2016 Siclo. All rights reserved.
//

import UIKit

class DrawableTile {
    
    var image: UIImage?
    let tileRect: CGRect
    
    init(rect: CGRect) {
        self.tileRect = rect
    }
    
    func draw() {
        image?.draw(in: tileRect, blendMode: .normal, alpha: 1.0)
    }
    
    func hasImage() -> Bool {
        return image != nil
    }
    
}
