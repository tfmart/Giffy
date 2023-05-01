//
//  Giffy.swift
//  GuruDesignSystem
//
//  Created by Tomas Martins on 27/04/23.
//  Copyright © 2023 Tomas Martins. All rights reserved.
//

import os
import UIKit
import SwiftUI
import FLAnimatedImage

/// A SwiftUI view that can display an animted GIF image that is stored locally. To present animation from a remote URL, use ``AsyncGiffy`` instead.
public struct Giffy: UIViewRepresentable {
    @ObservedObject internal var configuration: GiffyConfiguration
    private let contentSource: GiffyContentSource
    
    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let logger = Logger(
        subsystem: "Giffy",
        category: String(describing: Giffy.self)
    )
    
    /// Creates a view that can display an animated GIF image
    /// - Parameters:
    ///   - name: The name of the asset to be displayed by the `Giffy` view
    ///   - bundle: The bundle in which the asset is located
    public init(_ name: String, bundle: Bundle = .main) {
        self.contentSource = .fileName(name, bundle: bundle)
        self.configuration = .init()
    }
    
    /// Creates a view that can display an animated GIF image
    /// - Parameter imageData: The `Data` content of an GIF image
    public init(imageData: Data) {
        self.contentSource = .data(imageData)
        self.configuration = .init()
    }
    
    /// Creates a view that can display an animated GIF image
    /// - Parameter filePath: The path to the Lottie animation file
    ///
    /// This initializer should only be used for files that are stored locally. To load GIFs from a remote URL, use the ``AsyncGiffy`` view instead.
    public init(filePath: URL) {
        self.contentSource = .filePath(filePath)
        self.configuration = .init()
    }
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        setupImage(for: self.contentSource)
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        imageView.loopCompletionBlock = { _ in configuration.onLoopCompletion() }
    }
    
    private func setupImage(for contentSource: GiffyContentSource) {
        switch contentSource {
        case .data(let data):
            guard UIImage(data: data) != nil else {
                logger.warning("The provided file Data is not a valid image")
                return
            }
            let image = FLAnimatedImage(animatedGIFData: data)
            imageView.animatedImage = image
        case .fileName(let name, bundle: let bundle):
            guard let url = bundle.url(forResource: name, withExtension: "gif") else {
                logger.warning("Could not find image named \(name) in bundle \(bundle.bundlePath)")
                return
            }
            self.setupImage(for: .filePath(url))
        case .filePath(let url):
            guard let data = try? Data(contentsOf: url) else {
                logger.warning("Could not load the contents of file located at \(url.absoluteString)")
                return
            }
            self.setupImage(for: .data(data))
        }
    }
}

extension Giffy {
    /**
    Sets the block of code to be executed when the GIF animation has completed a full loop.

     - Parameter completion: A closure to be called when the GIF image has completed a loop.

     - Returns: A modified instance of Giffy with the block of code to be executed when the GIF animation has completed a full loop.

    Use this method to pass a closure that will be executed when the GIF animation has completed a full loop. The closure will receive an unsigned integer representing the number of times the animation has looped. You can use this value to determine if the animation has played a certain number of times or to trigger another action.
     
     ```swift
     Giffy("hello")
        .onLoopCompletion { _ in
            // ...
        }
     ```
    */
    func onLoop(_ completion: @escaping () -> Void) -> Giffy{
        self.configuration.onLoopCompletion = completion
        return self
    }
}
