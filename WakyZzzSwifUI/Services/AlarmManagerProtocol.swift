//
//  AlarmManagerProtocol.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 09/07/2024.
//

import Foundation

protocol AlarmManagerProtocol {
    var alarms: [Alarm] { get set }
    var randomActsOfKindness: [String] { get }

    func addAlarm(_ alarm: Alarm)
    func removeAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm)
    func getAlarm(by id: UUID?) -> Alarm?
    func snoozeAlarm(alarm: Alarm, completion: @escaping (Bool) -> Void)
}
