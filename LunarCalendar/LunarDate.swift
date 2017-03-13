//
//  LunarDate.swift
//  LunarCalendar
//
//  Created by Dat Nguyen on 1/1/17.
//  Copyright © 2017 Dat Nguyen. All rights reserved.
//

import Cocoa

class LunarDate: NSObject {
    //Variables
    private var _day: Int = 0
    private var _month: Int = 0
    private var _isLeapMonth: Bool = false
    private var _year: Int = 0
    private var _timeZone: Int = 7
    
    //Properties
    public var day:Int {
        get {
            return _day
        }
    }
    public var dayName:String {
        get {
            return ""
        }
    }
    public var month:Int {
        get {
            return _month
        }
    }
    public var monthName:String {
        get {
            return ""
        }
    }
    public var isLeapMonth:Bool {
        get {
            return _isLeapMonth
        }
    }
    public var year:Int {
        get {
            return _year
        }
    }
    public var yearName:String {
        get {
            return ""
        }
    }
    public var timeZone:Int {
        get {
            return _timeZone
        }
    }
    public var julianDayNumber:Int32 {
        get {
            return 0
        }
    }
    
    //Initiator
    init(day:Int, month:Int, isLeapMonth:Bool, year:Int, timeZone:Int) {
        _day = day
        _month = month
        _isLeapMonth = isLeapMonth
        _year = year
        _timeZone = timeZone
    }
    
    //Functions
    
}
