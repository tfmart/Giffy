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
    
    public init(url: URL,
                @ViewBuilder content: @escaping (GiffyPhase) -> Content) {
        self.content = content
        self.url = url
    }
    
    public var body: some View {
        content(phase)
            .task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let view = FLAnimatedImageViewRepresentable(imageData: data)
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
        Giffy(url: .init(string: "https://media.giphy.com/media/vFKqnCdLPNOKc/giphy.gif")!) { phase in
            switch phase {
            case .loading:
                Text("Loading...")
            case .error:
                Text("Error")
            case .success(let gif):
                gif
                    .frame(height: 120)
            }
        }
    }
}
