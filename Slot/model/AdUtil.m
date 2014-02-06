//
//  AdUtil.m
//  city
//
//  Created by qiuyonggang on 13-12-27.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AdUtil.h"

@implementation AdUtil
+(bool)isSameDay:(NSDate*) date1 date2:(NSDate*)date2
{
    if( date1 == nil){
        return false;
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
