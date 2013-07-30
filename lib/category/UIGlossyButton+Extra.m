//
//  UIGlossyButton+Extra.m
//  Shogun
//
//  Created by umeboshi on 13/07/09.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UIGlossyButton+Extra.h"

@implementation UIGlossyButton (Extra)

-(void)makeGlossyButton:(NSString*)title color:(UIColor*)color
{
	[self useWhiteLabel: YES];
    [self setGradientType:kUIGlossyButtonGradientTypeLinearSmoothExtreme];
    [self setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    self.tintColor = self.borderColor = color;
    [self setTitle:title forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

@end
