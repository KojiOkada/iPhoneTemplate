//
//  NSError+Extra.m
//  Shogun
//
//  Created by umeboshi on 13/07/03.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "NSError+Extra.h"

@implementation NSError (Extra)

+ (id)errorWithDict:(NSDictionary *)dict;
{
    return [self errorWithCode:0 userInfo:dict];
}

+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;
{
    NSString *domain = [NSBundle mainBundle].bundleIdentifier;
    return [NSError errorWithDomain:domain code:code userInfo:dict];
}

@end
