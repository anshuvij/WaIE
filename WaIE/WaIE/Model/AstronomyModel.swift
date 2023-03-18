//
//  AstronomyModel.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation

struct AstronomyModel: Codable {
    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let service_version: String
    let title: String
    let url: String
}
