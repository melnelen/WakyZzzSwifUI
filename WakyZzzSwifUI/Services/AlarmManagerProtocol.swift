//
//  AlarmManagerProtocol.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 09/07/2024.
//

import Foundation

protocol AlarmManagerProtocol {
    var alarms: [Alarm] { get set }
    func addAlarm(_ alarm: Alarm)
    func removeAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm)
}
