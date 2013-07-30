//
//  NSMutableDictionary+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "NSMutableDictionary+Extra.h"

@implementation NSMutableDictionary (Extra)

-(void)addObject:(id)anObject forKey:(id <NSCopying>)aKey;
{
    if(anObject == nil || aKey == nil){
        DebugLog(@"object %@, key =  %@", anObject, aKey);
        return;
    }
    [self setObject:anObject forKey:aKey];
}

-(void)setDate:(NSDate*)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject == nil || aKey == nil){
        DebugLog(@"object %@, key =  %@", anObject, aKey);
        return;
    }
    
    else if([anObject isKindOfClass:[NSDate class]]){
        NSDateFormatter *fmat=[[NSDateFormatter alloc] init];
        [fmat setLocale:[NSLocale systemLocale]];
        [fmat setTimeZone:[NSTimeZone systemTimeZone]];
        [fmat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self setObject:[fmat stringFromDate:anObject] forKey:(id)aKey];
    }
}

-(void)setNumber:(NSNumber*)anObject forKey:(id <NSCopying>)aKey validZero:(BOOL)validZero
{
    if(anObject == nil || aKey == nil){
        DebugLog(@"object %@, key =  %@", anObject, aKey);
        return;
    }
    
    if([anObject isKindOfClass:[NSNumber class]]){
        if(validZero == YES){
            if([anObject intValue] >= 0){
                [self setObject:[anObject stringValue] forKey:(id)aKey];
            }
        }
        else{
            if([anObject intValue] > 0){
                [self setObject:[anObject stringValue] forKey:(id)aKey];
            }
        }
    }
}

-(void)setString:(NSString*)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject == nil || aKey == nil){
        DebugLog(@"object %@, key =  %@", anObject, aKey);
        return;
    }
    if([anObject isKindOfClass:[NSString class]]){
        if([anObject length] > 0){
            [self setObject:anObject forKey:(id)aKey];
        }
    }
}

@end

