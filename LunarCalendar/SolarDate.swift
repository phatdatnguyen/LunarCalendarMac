//
//  SolarDate.swift
//  LunarCalendar
//
//  Created by Dat Nguyen on 1/1/17.
//  Copyright © 2017 Dat Nguyen. All rights reserved.
//

import Cocoa

class SolarDate: NSObject {
    //Variables
    private var _day:Int = 0
    private var _month:Int = 0
    private var _year:Int = 0
    private var _julianDayNumber:Int32 = 0
    
    //Properties
    public var day:Int {
        get {
            return _day
        }
    }
    public var dayOfWeek:String {
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
            switch _month {
                case 1: return "Tháng một";
                case 2: return "Tháng hai";
                case 3: return "Tháng ba";
                case 4: return "Tháng tư";
                case 5: return "Tháng năm";
                case 6: return "Tháng sáu";
                case 7: return "Tháng bảy";
                case 8: return "Tháng tám";
                case 9: return "Tháng chín";
                case 10: return "Tháng mười";
                case 11: return "Tháng mười một";
                default: return "Tháng mười hai";
            }
        }
    }
    public var year:Int {
        get {
            return _year
        }
    }
    public var julianDayNumber:Int32 {
        get {
            return _julianDayNumber
        }
    }
    
    //Initiator
    init(day:Int, month:Int, year:Int) {
        _day = day
        _month = month
        _year = year
        
        let a:Int = (14 - month) / 12;
        let y:Int = year + 4800 - a;
        let m:Int = month + 12 * a - 3;
        _julianDayNumber = Int32(day) + Int32((153 * m + 2) / 5) + Int32(365 * y) + Int32(y / 4) - Int32(y / 100) + Int32(y / 400) - 32045
        if (_julianDayNumber < 2299161)
        {
            _julianDayNumber = Int32(_day) + Int32((153 * m + 2) / 5) + Int32(365 * y + y / 4) - 32083
        }
    }
    init(julianDayNumber:Int32) {
        _julianDayNumber = julianDayNumber
        var a:Int32 = 0
        var b:Int32 = 0
        var c:Int32 = 0
        if _julianDayNumber > 2299160 {
            a = _julianDayNumber + 32044
            b = (4 * a + 3) / 146097
            c = a - (b * 146097) / 4
        }
        else {
            b = 0
            c = julianDayNumber + 32082
        }
        let d:Int32 = (4 * c + 3) / 1461
        let e:Int32 = c - (1461 * d) / 4
        let m:Int32 = (5 * e + 2) / 153
        _day = Int(e - (153 * m + 2) / 5 + 1)
        _month = Int(m + 3 - 12 * (m / 10))
        _year = Int(b * 100 + d - 4800 + m / 10)
    }
    
    //Functions
    public func toLunarDate(timeZone:Int) -> LunarDate {
        return LunarDate(day:0, month:0, isLeapMonth:false, year:0, timeZone:timeZone)
    }
}
