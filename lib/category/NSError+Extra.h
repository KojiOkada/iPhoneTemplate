//
//  NSError+Extra.h
//  Shogun
//
//  Created by umeboshi on 13/07/03.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <Foundation/Foundation.h>

enum kErrorCode {
    kErrorCodeConnectionError = -1,
    kErrorCodeNoConnection = -2,
};

@interface NSError (Extra)

+ (id)errorWithDict:(NSDictionary *)dict;
+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;

@end
