//
//  Breathe.swift
//  Feedback
//
//  Created by yanguo sun on 2022/1/12.
//

import Foundation


struct Breathe {
    enum BreathType {
        case `in`
        case out
    }
    var deep: Double = 0.25
    var type = BreathType.in
}
