# SCTiledImage
Tiled Image view for iOS: display images with multiple layers of zoom / tiles

##Demo
`input your demo MAxime`

![alt text](https://github.com/dblock/ARTiledImageView/raw/master/Screenshots/goya3.gif "Demo")

##Usage

Add this to your module's build.gradle
```javascript
ARWebTiledImageDataSource *ds = [[ARWebTiledImageDataSource alloc] init];
// height of the full zoomed in image
ds.maxTiledHeight = 2933;
// width of the full zommed in image
ds.maxTiledWidth = 2383;
// width of the full zommed in image
ds.minTileLevel = 10;
// maximum tile level
ds.maxTileLevel = 15;
// side of a square tile
ds.tileSize = 512;
// tile format
ds.tileFormat = @"jpg";
// location of tiles, organized in subfolders, one per level
ds.tileBaseURL = [NSURL URLWithString:@"https://raw.github.com/dblock/ARTiledImageView/master/Demo/Tiles/SenoraSabasaGarcia/tiles"];
// make sure to retain the datasource
_dataSource = ds;

ARTiledImageScrollView *sv = [[ARTiledImageScrollView alloc] initWithFrame:self.view.bounds];
// set datasource
sv.dataSource = ds;
// default background color
sv.backgroundColor = [UIColor grayColor];
// default stretched placeholder image
sv.backgroundImageURL = [NSURL URLWithString:@"https://raw.github.com/dblock/ARTiledImageView/master/Demo/Tiles/SenoraSabasaGarcia/large.jpg"];
// display tile borders, for debugging
sv.displayTileBorders = NO;

// add as a subview to another view
[self.view addSubview:sv];
```
For full example, please refer to sample

###Tiles and Data Sources
A typical organization for deep zoom map tiles consists of a folder for each zoom level and individual JPG files for each tile. You can see an example of such files here. ARTiledImageView comes with a local ARLocalTiledImageDataSource, which retrieves tile files from local storage, and a remote ARWebTiledImageDataSource data source, which retrieves map tiles from a remote URL and stores them in Library/Caches (NSCachesDirectory).

You can generate tiles using dzt or any other tool listed with the OpenSeadragon project.

###Installation
ARTiledImageView is available through CocoaPods, to install it simply add the following line to your Podfile:
```javascript
   pod "ARTiledImageView"
```


##Contribution

####Questions
If you have any questions regarding SCTiledImage, create an Issue

####Feature request, new features?
We are still working on it to add more useful option/feature,
to create a new feature request, open an issue

I'll try to answer as soon as I find the time.

####Pull requests welcome

Feel free to contribute to SCTiledImage.

Either you found a bug or have created a new and awesome feature, just create a pull request.


##License
Copyright 2016 Siclo Mobile Vietnam
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
