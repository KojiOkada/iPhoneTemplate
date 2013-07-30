//
//  NSMutableArray+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "NSMutableArray+Extra.h"

@implementation NSMutableArray (Extra)

-(BOOL)addObjectIfNotExists:(id)e{
    if (e==nil) {
        return NO;
    }
    
    for (int i=0; i<[self count]; i++) {
        if ([self objectAtIndex:i]==e) {
            return NO;
        }
    }
    
    [self addObject:e];
    return YES;
}

@end

