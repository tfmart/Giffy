//
//  GiffyContentSource.swift
//  
//
//  Created by Tomas Martins on 27/04/23.
//

import Foundation

enum GiffyContentSource {
    case name(String, bundle: Bundle)
    case url(URL)
    
    var urlForResource: URL? {
        switch self {
          case .name(let name, let bundle):
            return bundle.url(forResource: name, withExtension: "gif")
          case .url(let url):
            return url
        }
      }
}
