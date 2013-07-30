//
//  NSDate+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "NSDate+Extra.h"

@implementation NSDate(Extra)

-(NSString*)toString;
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ja"]];
    [fmt setTimeZone:[NSTimeZone systemTimeZone]];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [fmt stringFromDate:self];
}
-(NSDate*)addDay:(NSInteger)day
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    return [cal dateByAddingComponents:comps toDate:self options:0];
}

-(NSDate*)addMonth:(NSInteger)month
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    return [cal dateByAddingComponents:comps toDate:self options:0];
}

-(NSDate*)addYear:(NSInteger)year
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:year];
    return [cal dateByAddingComponents:comps toDate:self options:0];
}

-(BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    if(aDate == nil) return NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents *components1 = [calendar components:unit fromDate:self];
    NSDateComponents *components2 = [calendar components:unit fromDate:aDate];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}

@end

