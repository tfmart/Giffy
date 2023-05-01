//
//  AsyncGiffyPhase.swift
//  
//
//  Created by Tomas Martins on 27/04/23.
//

import Foundation

public enum AsyncGiffyPhase {
    case loading
    case error
    case success(Giffy)
}
