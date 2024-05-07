//
//  NetworkMonitoring.swift
//  QRcommissioning
//
//  Created by sid on 06/02/24.
//

import Foundation
import Network

class NetworkMonitoring: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    //@Published var ipAddress: NWEndpoint?
    @Published var monitoringState: NWPath.Status = .unsatisfied
    @Published var networkInterface: NWInterface.InterfaceType = .other
    
    init(){
        monitor.pathUpdateHandler = { path in
            
            DispatchQueue.main.async {
                self.monitoringState = path.status
                let connectionType: [NWInterface.InterfaceType] = [.wifi, .wiredEthernet]
                self.networkInterface = connectionType.first(where: path.usesInterfaceType) ?? .other
            }
            
        }
        
        monitor.start(queue: queue)
    }
}
