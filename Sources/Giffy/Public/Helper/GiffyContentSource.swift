//
//  File.swift
//  
//
//  Created by Tomas Martins on 28/04/23.
//

import Foundation

public enum GiffyContentSource {
    case data(Data)
    case fileName(String, bundle: Bundle = .main)
    case filePath(URL)
}
