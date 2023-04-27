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

public struct FLAnimatedImageViewRepresentable: UIViewRepresentable {
    var imageData: Data
    
    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        let image = FLAnimatedImage(animatedGIFData: imageData)
        DispatchQueue.main.async {
            imageView.animatedImage = image
        }
    }
}
