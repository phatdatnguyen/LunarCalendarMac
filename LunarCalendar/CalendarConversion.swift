//
//  CalendarConversion.swift
//  LunarCalendar
//
//  Created by Dat Nguyen on 1/1/17.
//  Copyright © 2017 Dat Nguyen. All rights reserved.
//

import Cocoa

class CalendarConversion: NSObject {
    //Error
    
    enum CalenderConversionError: Error {
        case outOfLimit
        case invalidLunarDate
    }
    
    //Functions
    private static func newMoon(k:Int32) -> Double {
        let T:Double = Double(k) / 1236.85
        let T2:Double = T * T
        let T3:Double = T2 * T
        let dr:Double = Double.pi / 180
        var Jd1:Double = 2415020.75933
        Jd1 += 29.53058868 * Double(k)
        Jd1 += 0.0001178 * T2
        Jd1 -= 0.000000155 * T3
        Jd1 += 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr) // Mean new moon
        var M:Double = 359.2242
        M += 29.10535608 * Double(k)
        M -= 0.0000333 * T2
        M -= 0.00000347 * T3 // Sun's mean anomaly
        var Mpr:Double = 306.0253
        Mpr += 385.81691806 * Double(k)
        Mpr += 0.0107306 * T2
        Mpr += 0.00001236 * T3 // Moon's mean anomaly
        var F:Double = 21.2964
        F += 390.67050646 * Double(k)
        F -= 0.0016528 * T2
        F -= 0.00000239 * T3 // Moon's argument of latitude
        var C1:Double = (0.1734 - 0.000393 * T) * sin(M * dr)
        C1 += 0.0021 * sin(2 * dr * M)
        C1 -= 0.4068 * sin(Mpr * dr)
        C1 += 0.0161 * sin(dr * 2 * Mpr)
        C1 -= 0.0004 * sin(dr * 3 * Mpr)
        C1 += 0.0104 * sin(dr * 2 * F)
        C1 -= 0.0051 * sin(dr * (M + Mpr))
        C1 -= 0.0074 * sin(dr * (M - Mpr))
        C1 += 0.0004 * sin(dr * (2 * F + M))
        C1 -= 0.0004 * sin(dr * (2 * F - M))
        C1 -= 0.0006 * sin(dr * (2 * F + Mpr))
        C1 += 0.0010 * sin(dr * (2 * F - Mpr))
        C1 += 0.0005 * sin(dr * (2 * Mpr + M))
        var dt:Double = 0
        if (T < -11)
        {
            dt = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3;
        }
        else
        {
            dt = -0.000278 + 0.000265 * T + 0.000262 * T2;
        };
        let JdNew:Double = Jd1 + C1 - dt;
        return JdNew;
    }
    public static func getNewMoonDay(k:Int32, timeZone:Int) -> Int32
    {
        return Int32(floor(newMoon(k:k) + 0.5 + Double(timeZone) / 24.0))
    }
    private static func sunLongitude(jdn:Double) -> Double
    {
        let T:Double = (jdn - 2451545.0) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
        let T2:Double = T * T
        let dr:Double = Double.pi / 180; // degree to radian
        var M:Double = 357.5291
        M += 35999.0503 * T
        M -= 0.0001559 * T2
        M -= 0.00000048 * T * T2 // mean anomaly, degree
        var L0:Double = 280.46645
        L0 += 36000.76983 * T
        L0 += 0.0003032 * T2 // mean longitude, degree
        var dL:Double = (1.9146 - 0.004817 * T - 0.000014 * T2) * sin(dr * M)
        dL += (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.00029 * sin(dr * 3 * M)
        var L:Double = L0 + dL // true longitude, degree
        L *= dr;
        L -= Double.pi * 2 * (floor(L / (Double.pi * 2))); // Normalize to (0, 2*PI)
        return L
    }
    private static func getSunLongitude(dayNumber:Double, timeZone:Int) -> Int32
    {
        return Int32(floor(sunLongitude(jdn:(dayNumber - 0.5 - Double(timeZone) / 24.0)) / Double.pi * 6))
    }
    private static func getLunarMonth11(year:Int, timeZone:Int) -> Int32
    {
        let solarDate = SolarDate(day:31, month:12, year:year)
        let off:Double = Double(solarDate.julianDayNumber) - 2415021.076998695
        let k:Int32 = Int32(floor(off / 29.530588853))
        var nm:Int32 = getNewMoonDay(k:k, timeZone:timeZone)
        let sunLong:Double = Double(getSunLongitude(dayNumber:Double(nm), timeZone:timeZone)) // sun longitude at local midnight
        if (sunLong >= 9) {
            nm = getNewMoonDay(k:k - 1, timeZone:timeZone)
        }
        return nm;
    }
    private static func getLeapMonthOffset(a11:Double, timeZone:Int) -> Int
    {
        let k:Int32 = Int32(floor((a11 - 2415021.076998695) / 29.530588853 + 0.5))
        var last:Int32 = 0;
        var i:Int = 1; // We start with the month following lunar month 11
        var arc:Int32 = getSunLongitude(dayNumber:Double(getNewMoonDay(k:k + i, timeZone:timeZone)), timeZone:timeZone)
        repeat {
            last = arc
            i += 1
            arc = getSunLongitude(dayNumber:Double(getNewMoonDay(k:k + i, timeZone:timeZone)), timeZone:timeZone);
        }
        while (arc != last && i < 14)
        return i - 1;
    }
    public static func convertSolarDateToLunarDate(solarDate:SolarDate, timeZone:Int) -> LunarDate
    {
        let dayNumber:Int32 = solarDate.julianDayNumber
        let k:Int32 = Int32(floor((Double(dayNumber) - 2415021.076998695) / 29.530588853))
        var monthStart:Int32 = getNewMoonDay(k:k + 1, timeZone:timeZone)
        if (monthStart > dayNumber) {
            monthStart = getNewMoonDay(k:k, timeZone:timeZone);
        }
        var a11:Int32 = getLunarMonth11(year:solarDate.year, timeZone:timeZone)
        var b11:Int32 = a11
        var lunarYear:Int = 0
        if (a11 >= monthStart) {
            lunarYear = solarDate.year
            a11 = getLunarMonth11(year:solarDate.year - 1, timeZone:timeZone)
        }
        else {
            lunarYear = solarDate.year + 1
            b11 = getLunarMonth11(year:solarDate.year + 1, timeZone:timeZone)
        }
        let lunarDay:Int = Int(dayNumber - monthStart + 1)
        let diff:Int = Int(floor(Double((monthStart - a11) / 29)))
        var lunarLeap:Bool = false
        var lunarMonth:Int = diff + 11
        if (b11 - a11 > 365) {
            let leapMonthDiff:Int = getLeapMonthOffset(a11:Double(a11), timeZone:timeZone)
            if (diff >= leapMonthDiff) {
                lunarMonth = diff + 10
                if (diff == leapMonthDiff) {
                    lunarLeap = true;
                }
            }
        }
        if (lunarMonth > 12) {
            lunarMonth = lunarMonth - 12
        }
        if (lunarMonth >= 11 && diff < 4) {
            lunarYear -= 1;
        }
        return LunarDate(day:lunarDay, month:lunarMonth, isLeapMonth:lunarLeap, year:lunarYear, timeZone:timeZone)
    }
    
    public static func convertLunarDateToSolarDate(lunarDate:LunarDate) throws -> SolarDate
    {
        if ((lunarDate.year < 0) || (lunarDate.year == 0 && lunarDate.month < 11) || (lunarDate.year == 0 && lunarDate.month == 11 && lunarDate.day < 19)) {
            throw CalenderConversionError.outOfLimit
        }
        if ((lunarDate.year > 9999) || (lunarDate.year == 9999 && lunarDate.month == 12 && lunarDate.day > 2)) {
            throw CalenderConversionError.outOfLimit
        }
    
        var a11:Int32 = 0
        var b11:Int32 = 0
        if (lunarDate.month < 11) {
            a11 = getLunarMonth11(year:lunarDate.year - 1, timeZone:lunarDate.timeZone)
            b11 = getLunarMonth11(year:lunarDate.year, timeZone:lunarDate.timeZone)
        }
        else {
            a11 = getLunarMonth11(year:lunarDate.year, timeZone:lunarDate.timeZone)
            b11 = getLunarMonth11(year:lunarDate.year + 1, timeZone:lunarDate.timeZone)
        }
        let k:Int32 = Int32(floor(0.5 + (Double(a11) - 2415021.07699869) / 29.530588853))
        var off:Int = lunarDate.month - 11;
        if (off < 0) {
            off = off + 12;
        }
        if (b11 - a11 > 365) {
            let leapOff:Int = getLeapMonthOffset(a11:Double(a11), timeZone:lunarDate.timeZone);
            var leapMonth:Int = leapOff - 2;
            if (leapMonth < 0) {
                leapMonth = leapMonth + 12;
            }
            if (lunarDate.isLeapMonth && lunarDate.month != leapMonth) {
                throw CalenderConversionError.invalidLunarDate
            }
            if (lunarDate.isLeapMonth || off >= leapOff) {
                off = off + 1;
            }
        }
        let monthStart:Int32 = getNewMoonDay(k:k + off, timeZone:lunarDate.timeZone);
        return SolarDate(julianDayNumber:monthStart + lunarDate.day - 1);
    }
}
