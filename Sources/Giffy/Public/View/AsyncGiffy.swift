//
//  Giffy.swift
//  
//
//  Created by Tomas Martins on 27/04/23.
//

import os
import SwiftUI

/// A SwiftUI view that can display an animted GIF image from a remote URL. To present an GIF image that is stored locally, use the ``Giffy`` component instead.
public struct AsyncGiffy<Content: View>: View {
    @ViewBuilder
    private let content: (AsyncGiffyPhase) -> Content
    @State private var phase: AsyncGiffyPhase = .loading
    
    let url: URL
    
    private let logger = Logger(
        subsystem: "Giffy",
        category: String(describing: AsyncGiffy.self)
    )
    
    /// Creates a view that presents an animted GIF image from a remote URL to be displayed in phases
    /// - Parameters:
    ///   - url: The remote URL of an animated GIF image to be displayed
    ///   - content: A closure that takes the current phase as an input and returns the view to be displayed in each phase
    public init(url: URL,
                @ViewBuilder content: @escaping (AsyncGiffyPhase) -> Content) {
        self.content = content
        self.url = url
    }
    
    public var body: some View {
        content(phase)
            .task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let view = Giffy(imageData: data)
                    self.phase = .success(view)
                } catch {
                    logger.warning("Could not get data for GIF file located at \(url.absoluteString)")
                    self.phase = .error
                }
            }
    }
}

struct Giffy_Previews: PreviewProvider {
    static var previews: some View {
        AsyncGiffy(url: .init(string: "https://media.giphy.com/media/vFKqnCdLPNOKc/giphy.gif")!) { phase in
            switch phase {
            case .loading:
                Text("Loading...")
            case .error:
                Text("Error")
            case .success(let gif):
                gif
                    .onLoop {
                        print("Finished looping!")
                    }
                    .frame(height: 120)
            }
        }
    }
}
