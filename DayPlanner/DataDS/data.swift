//
//  data.swift
//  DayPlanner
//
//  Created by Usama Fouad on 16/03/2021.
//

import UIKit
import WidgetKit


var selectedDayInd: Int! = 0

// daysPlans: is a dictionary that holds the day index, and 1D array which contains allCards (Done and not done).
var daysPlans = [Int:[[PlanCard]]]() {
    didSet {
        saveData()
    }
}

var currentDayUnDoneCards = [PlanCard]() {
    didSet {
        daysPlans[selectedDayInd, default: []][0] = currentDayUnDoneCards
    }
}
var currentDayDoneCards = [PlanCard]()  {
    didSet {
        daysPlans[selectedDayInd, default: []][1] = currentDayDoneCards
    }
}

var colorButtons = [UIButton]()

let arrowsImages = ["redarrow", "bluearrow", "blackarrow", "orange", "purplearrow", "greenarrow"]

var isSettingsApplyToAll = false

var OnClickGlobalSettings = [Bool]()
var alwaysGlobalSettings = [Bool]()

var onClickGlobalDisplayCard: DisplayType!
var alwaysGlobalDisplayCard: DisplayType!

func saveData() {
    let jsonEncoder = JSONEncoder()
    let defaults = UserDefaults(suiteName: "group.usamaWidgetCache")
    
    if let savedData = try? jsonEncoder.encode(daysPlans) {
        defaults?.set(savedData, forKey: "daysPlans")
        WidgetCenter.shared.reloadAllTimelines()
    } else {
        print("Failed to save data")
    }
        
}


func loadData() -> Bool {
    let defaults = UserDefaults(suiteName: "group.usamaWidgetCache")
            
    if let data = defaults?.object(forKey: "daysPlans") as? Data {
        let jsonDecoder = JSONDecoder()
        
        do {
            daysPlans = try jsonDecoder.decode([Int:[[PlanCard]]].self, from: data)
            return true
        } catch {
            print("Couldn't load the cards!")
        }
    }
    return false
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
