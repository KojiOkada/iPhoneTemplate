//
//  Category.m
//  Shogun
//
//  Created by システム管理者 on 13/06/26.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "CategoryHeader.h"

@implementation CategoryHeader

@end
@implementation NSNull(IgnoreMessages)

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig=[[NSNull class] instanceMethodSignatureForSelector:aSelector];
    // Just return some meaningless signature
    if (sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    
    return sig;
}
@end
