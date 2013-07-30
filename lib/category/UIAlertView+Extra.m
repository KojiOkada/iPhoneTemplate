//
//  UIAlertView+Extra.m
//  Shogun
//
//  Created by umeboshi on 13/06/26.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UIAlertView+Extra.h"

@implementation UIAlertView (Extra)

+(void)showMsg:(NSString*)title msg:(NSString*)msg
{
    [UIAlertView showAlertViewWithTitle:title message:msg cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
}

@end
