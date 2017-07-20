//
//  TiledImageRotation.swift
//  AEXML
//
//  Created by Maxime POUWELS on 18/07/2017.
//

import Foundation
import CoreGraphics

public enum SCTiledImageRotation {
    case none
    case right
    case left
    case half
    
    public var angleInRadians: Double {
        switch self {
        case .none:
            return 0
        case .right:
            return -Double.pi/2
        case .half:
            return Double.pi
        case .left:
            return Double.pi/2
        }
    }
    
    public var opposite: SCTiledImageRotation {
        switch self {
        case .none:
            return .none
        case .right:
            return .left
        case .half:
            return .half
        case .left:
            return .right
        }
    }
    
    public func rotate(_ image: UIImage) -> UIImage? {
        return image.rotated(angleInRadians: CGFloat(angleInRadians))
    }
    
    public func rotate(_ point: CGPoint) -> CGPoint {
        switch self {
        case .none:
            return point
        case .right:
            return CGPoint(x: -point.y, y: point.x)
        case .left:
            return CGPoint(x: point.y, y: -point.x)
        case .half:
            return CGPoint(x: -point.x, y: -point.y)
        }
    }
    
    public func rotate(_ point: CGPoint, in imageSize: CGSize) -> CGPoint {
        switch self {
        case .none:
            return point
        case .right:
            return CGPoint(x: imageSize.height - point.y, y: point.x)
        case .left:
            return CGPoint(x: point.y, y: imageSize.width - point.x)
        case .half:
            return CGPoint(x: imageSize.width - point.x, y: imageSize.height - point.y)
        }
    }

    public func rotate(_ rect: CGRect, in imageSize: CGSize) -> CGRect {
        switch self {
        case .none:
            return rect
        case .right:
            return CGRect(x: imageSize.height - (rect.origin.y + rect.height), y: rect.origin.x, width: rect.height, height: rect.width)
        case .half:
            return CGRect(x: imageSize.width - (rect.origin.x + rect.width), y: imageSize.height - (rect.origin.y + rect.height), width: rect.width, height: rect.height)
        case .left:
            return CGRect(x: rect.origin.y, y: imageSize.width - (rect.origin.x + rect.width), width: rect.height, height: rect.width)
        }
    }
    
    public func rotate(_ size: CGSize) -> CGSize {
        switch self {
        case .none, .half:
            return size
        case .left, .right:
            return CGSize(width: size.height, height: size.width)
        }
    }
    
}

extension UIImage {
    func rotated(angleInRadians radians: CGFloat) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        let originalWidth = cgImage.width
        let originalWidthFloat = CGFloat(cgImage.width)
        let originalHeight = cgImage.height
        let originalHeightFloat = CGFloat(cgImage.height)
        let imgRect = CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight)
        let rotatedRect = imgRect.applying(CGAffineTransform(rotationAngle: radians))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        guard let bmContext = CGContext(data: nil, width: Int(rotatedRect.size.width), height: Int(rotatedRect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        bmContext.setShouldAntialias(true)
        bmContext.setAllowsAntialiasing(true)
        bmContext.interpolationQuality = .high
        
        bmContext.translateBy(x: rotatedRect.size.width * 0.5, y: rotatedRect.size.height * 0.5)
        bmContext.rotate(by: radians)
        
        let drawRect = CGRect(x: -originalWidthFloat*0.5, y: -originalHeightFloat*0.5, width: CGFloat(originalWidth), height: CGFloat(originalHeight))
        bmContext.draw(cgImage, in: drawRect)
        
        guard let rotatedImageRef = bmContext.makeImage() else {
            return nil
        }
        let rotatedImage = UIImage(cgImage: rotatedImageRef)
        return rotatedImage
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
