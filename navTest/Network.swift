//
//  Network.swift
//  improvedDice
//
//  Created by IACD-022 on 2022/07/21.
//

import Foundation
import Network

class NetworkCheck: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    
}
