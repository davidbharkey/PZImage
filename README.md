# PZImage
A view that displays an image or series of images with a canvas pan-and-zoom effect.

https://github.com/davidbharkey/PZImage/assets/6327657/ae881ab9-edfd-4cc6-901c-633c10bf0e31

A `PZImage` view can be constructed with either one image from the app asset catalog, or with an array of images from the app asset catalog. You can initialize a `PZImage` with either one `ImageResource` argument or with an array of `ImageResource`s. If only one image is displayed, the `changeImageTime` property is ignored, and the image will pan and zoom across the same image randomly over the course of the `zoomPanTime` value.

All properties are optional except the image or array of images to be displayed.

***Warning***: You should visually test all images to ensure an under-zoom out of the full image or over-pan out of the bounds of the image does not occur.
* `minZoomLevel` `*` `imageFrameWidth` should be less than the width of the original image.
* `maxZoomLevel` `*` `imageFrameHeight` should be less than the height of the original image.

Parameters:
  - `imageFrameHeight`: The height of the image carousel frame (default: 200.0)
  - `imageFrameWidth`: The width of the image carousel frame (default: screen width)
  - `imageOpacity`: The opacity of the images in the carousel (default: 1.0)
  - `changeImageTime`: The duration an image should be displayed before cycling to the next (default: 10.0 seconds)
  - `zoomPanTime`: The duration of the zoom & pan effect when transitioning to a new image (default: 5.0 seconds)
  - `maxZoomLevel`: The maximum zoom level of the image (default: 7)
  - `minZoomLevel`: The minimum zoom level of the image (default: 3)
