//
//  NSDate+Extra.h
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate(Extra)

-(NSString*)toString;
-(NSDate*)addDay:(NSInteger)day;
-(NSDate*)addMonth:(NSInteger)month;
-(NSDate*)addYear:(NSInteger)Year;
-(BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;

@end
