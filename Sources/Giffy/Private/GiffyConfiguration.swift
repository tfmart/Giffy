//
//  GiffyConfiguration.swift
//  
//
//  Created by Tomas Martins on 27/04/23.
//

import Foundation
import UIKit

class GiffyConfiguration: ObservableObject {
    @Published var onLoopCompletion: () -> Void = { }
}
