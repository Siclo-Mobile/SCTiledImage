# SCTiledImage
Tiled Image view for iOS: display images with multiple layers of zoom / tiles (as GoogleMaps does for instance).  
This allows to load very large images at high resolution, and as the user zooms or scrolls, more details are loaded.  

The image must be cut into tiles of multiple levels of zoom.  
The level 0 is the highest resolution level (when user scrolls to the maximum), each tile of the next level is composed of 2x2 tiles of the lower level (e.g. 4 tiles of level 0 will make 1 tile at level 1).

### Installation
SCTiledImage is available through CocoaPods, to install it simply add the following line to your Podfile:
```ruby
   pod "SCTiledImage"
```

### Features
SCTiledImage supports the following functionalities:
- Display large image as tiles with multiple layers of zoom, in a subclass of UIScrollView
- Double tap or two-finger tap to zoom on the image
- Custom tile sizes (common size is 256 x 256) and number of zoom levels
- Image can be displayed with 90, 180 or -90 degrees rotation
- Lazy loading of images (e.g. from Network or Local Disk), with in-memory cache
- Background image (low resolution) displayed while tiles are loading
- Delegate callbacks when user zooms or scrolls

### Example
You can download this repository and build the demo app to see an example (original image is 9112 x 4677 = ~42 mega pixels)

### Usage
1. Implement a `SCTiledImageScrollView`, either in code or in Interface Builder: this will be the view that displays the image
2. Instantiate an object that implements the `SCTiledImageViewDataSource` protocol, and pass it to your `SCTiledImageScrollView` instance through its `.set(dataSource:)` method
3. Optionally, you can set a `SCTiledImageScrollViewDelegate` to the `SCTiledImageScrollView` instance to be notified when user scrolls or zooms

See the example for more details of implementation, and for an example of tiles (inside the "HoiAn" folder).

##### DataSource
The `SCTiledImageViewDataSource` protocol requires the following to be imlpemented:
```swift
  weak var delegate: SCTiledImageViewDataSourceDelegate?
  // delegate to call once tile images have been loaded (from network, local disk...)

  let imageSize: CGSize
  // size of the full resolution image

  let tileSize: CGSize
  // size of the tiles

  let zoomLevels: Int
  // number of zoom levels

  func requestTiles(_ tiles: [SCTile])
  // called by the SCTiledImageScrollView when some tiles are need, this function must retrieve these tiles (SCTile = row, column, level) and then call the delegate once a tile is ready

  func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ())
  // called by the SCTiledImageScrollView, used to return the optional background image to display when tiles are loading (low resolution version of the full image)

  func getCachedImage(for tile: SCTile) -> UIImage?
  // if images can be retrieve synchronously (because already cached) then this function can return them directly to improve rendering speed
  // in this case, it will replace requestTiles(_ tiles: [SCTile])
  // if not, return nil and requestTiles(_ tiles: [SCTile]) will be used
```

## License
Copyright 2016-2018 Siclo Mobile
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
