//
//  IpModel.swift
//  QRcommissioning
//
//  Created by sid on 06/02/24.
//

import Foundation

struct PublicIpAddressResult: Codable {
    let request: ClientValue
}

struct ClientValue: Codable {
    let client: PublicIpAddress
}

struct PublicIpAddress: Codable{
    let ip: String
}


struct IPAddressValue: Codable {
    let public_ip: String
    let internal_ip: String
}

struct JamfIDResult: Codable {
    let Jamf_id: Int?
    let detail: String?
}
