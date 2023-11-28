//
//  HeartRateViewModel.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 27.11.2023.
//

import Foundation
import Combine

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 0
}
