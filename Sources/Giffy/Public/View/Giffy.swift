//
//  GiffyViewRepresentable.swift
//  GuruDesignSystem
//
//  Created by Tomas Martins on 27/04/23.
//  Copyright © 2023 Tomas Martins. All rights reserved.
//

import UIKit
import SwiftUI
import FLAnimatedImage

public struct Giffy: UIViewRepresentable {
    var imageData: Data
    @ObservedObject internal var configuration: GiffyConfiguration
    
    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    internal init(data: Data) {
        self.imageData = data
        self.configuration = .init()
    }
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        let image = FLAnimatedImage(animatedGIFData: imageData)
        imageView.animatedImage = image
        imageView.loopCompletionBlock = { _ in configuration.onLoopCompletion() }
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
