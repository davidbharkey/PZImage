//
//  PZImage.swift
//  PZImage
//
//  Created by David Harkey on 10/12/23.
//

import SwiftUI

/// A view that displays an image or series of images with a canvas pan-and-zoom effect.
///
/// A **PZImage** view can be constructed with either one image from the app asset catalog, or with an array of images from the app asset catalog. You can initialize a **PZImage** with either one **ImageResource** argument or with an array of **ImageResource**s. If only one image is displayed, the **changeImageTime** property is ignored, and the image will pan and zoom across the same image randomly over the course of the **zoomPanTime** value.
///
/// All properties are optional except the image or array of images to be displayed.
///
/// - Warning: You should visually test all images to ensure an under-zoom out of the full image or over-pan out of the bounds of the image does not occur.
/// * **minZoomLevel** `*`  **imageFrameWidth** should be less than the width of the original image.
/// * **maxZoomLevel** `*` **imageFrameHeight** should be less than the height of the original image.
///
/// - Parameters:
///   - imageFrameHeight: The height of the image carousel frame (default: 200.0)
///   - imageFrameWidth: The width of the image carousel frame (default: screen width)
///   - imageOpacity: The opacity of the images in the carousel (default: 1.0)
///   - changeImageTime: The duration an image should be displayed before cycling to the next (default: 10.0 seconds)
///   - zoomPanTime: The duration of the zoom & pan effect when transitioning to a new image (default: 5.0 seconds)
///   - minZoomLevel: The minimum zoom level of the image (default: 3)
///   - maxZoomLevel: The maximum zoom level of the image (default: 7)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PZImage: View {
    private var imageFrameHeight: CGFloat
    private var imageFrameWidth: CGFloat
    private var imageOpacity: Double
    private var changeImageTime: TimeInterval
    private var zoomPanTime: TimeInterval
    private var minZoomLevel: Int
    private var maxZoomLevel: Int
    
    @State private var images: [ImageResource] = []
    @State private var timer: Timer? = nil
    @State private var panToX: Int = 0
    @State private var panToY: Int = 0
    @State private var scaleFactor: Double = 1
    @State private var imageWidth: CGFloat = 0
    @State private var imageHeight: CGFloat = 0
    @State private var minX: CGFloat = 0
    @State private var minY: CGFloat = 0
    
    init(_ images: [ImageResource], imageFrameHeight: CGFloat = 200.0, imageFrameWidth: CGFloat = UIScreen.main.bounds.width, imageOpacity: Double = 1.0, changeImageTime: TimeInterval = 5.0, zoomPanTime: TimeInterval = 5.0, minZoomLevel: Int = 3, maxZoomLevel: Int = 7) {
        self._images = State(initialValue: images)
        self.imageFrameHeight = imageFrameHeight
        self.imageFrameWidth = imageFrameWidth
        self.imageOpacity = imageOpacity
        self.changeImageTime = changeImageTime
        self.zoomPanTime = zoomPanTime
        self.minZoomLevel = minZoomLevel
        self.maxZoomLevel = maxZoomLevel
    }
    
    init(_ image: ImageResource, imageFrameHeight: CGFloat = 200.0, imageFrameWidth: CGFloat = UIScreen.main.bounds.width, imageOpacity: Double = 1.0, changeImageTime: TimeInterval = 5.0, zoomPanTime: TimeInterval = 5.0, minZoomLevel: Int = 3, maxZoomLevel: Int = 7) {
        self._images = State(initialValue: [image])
        self.imageFrameHeight = imageFrameHeight
        self.imageFrameWidth = imageFrameWidth
        self.imageOpacity = imageOpacity
        self.changeImageTime = changeImageTime
        self.zoomPanTime = zoomPanTime
        self.minZoomLevel = minZoomLevel
        self.maxZoomLevel = maxZoomLevel
    }

    public var body: some View {
        let selectedImage = images.randomElement()!
        VStack {
            Image(selectedImage)
                .offset(x: CGFloat(panToX), y: CGFloat(-panToY))
                .scaleEffect(scaleFactor)
                .opacity(imageOpacity)
        }
        .onAppear {
            let image = UIImage(resource: selectedImage)
            imageWidth = image.size.width
            imageHeight = image.size.height
            timer = Timer.scheduledTimer(withTimeInterval: changeImageTime, repeats: true) { timer in
                withAnimation(.easeInOut(duration: zoomPanTime)) {
                    scaleFactor = Double(Int.random(in: minZoomLevel...maxZoomLevel)) / 10
                    minX = scaleFactor * ((imageWidth / 2) - (imageFrameWidth / 2))
                    minY = scaleFactor * ((imageHeight / 2) - (imageFrameHeight / 2.0))
                    panToX = Int.random(in: Int(-minX)...Int(minX))
                    panToY = Int.random(in: Int(-minY)...Int(minY))
                }
            }
        }
        .onFirstAppear {
            timer?.fire()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .frame(width: imageFrameWidth, height: imageFrameHeight)
        .clipped()
    }
}


/*
    Credit for onFirstAppear View extension: https://www.swiftjectivec.com/swiftui-run-code-only-once-versus-onappear-or-task/
*/

fileprivate extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}

fileprivate struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

#Preview {
    PZImage([.bg1 ,.bg2, .bg3, .bg4, .bg5])
}
