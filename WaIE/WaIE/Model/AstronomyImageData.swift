//
//  AstronomyImageData.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation

struct AstronomyImageData: Cachable, Codable {
    var fileName: String = Constants.imageFileName
    let imageData: Data
}
