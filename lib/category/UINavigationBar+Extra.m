//
//  UINavigationBar+Extra.m
//  Shogun
//
//  Created by umeboshi on 13/07/29.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UINavigationBar+Extra.h"

@implementation UINavigationBar (Extra)

-(void)setTitleAdjustsFontSize:(NSString*)title;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = BASE_BOLDFONT(20);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = SHOP_TITLE(title);
    label.adjustsFontSizeToFitWidth = YES;
    self.topItem.titleView = label;
}

@end
