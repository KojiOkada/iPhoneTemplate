//
//  NSDictionary+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "NSDictionary+Extra.h"
#import "NSDate+Extra.h"

@implementation NSDictionary (Extra)

-(id)convertDateToString;
{
    NSMutableDictionary *dic = [self mutableCopy];
    for(NSString *key in [dic allKeys]){
        if([dic[key] isKindOfClass:[NSDate class]]){
            dic[key] = [dic[key] toString];
        }
    }
    return dic;
}

@end