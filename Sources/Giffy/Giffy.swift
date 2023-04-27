//
//  Giffy.swift
//  
//
//  Created by Tomas Martins on 27/04/23.
//

import os
import SwiftUI

public struct Giffy<Content: View>: View {
    @ViewBuilder
    private let content: (GiffyPhase) -> Content
    @State private var phase: GiffyPhase = .loading
    
    let url: URL
    
    private let logger = Logger(
        subsystem: "Giffy",
        category: String(describing: Giffy.self)
    )
    
    init(url: URL,
         @ViewBuilder content: @escaping (GiffyPhase) -> Content) {
        self.content = content
        self.url = url
    }
    
    public var body: some View {
        content(phase)
            .task {
                guard let data = try? Data(contentsOf: url),
                      UIImage(data: data) != nil else {
                    logger.warning("Could not get data for GIF file located at \(url.absoluteString)")
                    self.phase = .error
                    return
                }
                self.phase = .success(.init(imageData: data))
            }
    }
}
