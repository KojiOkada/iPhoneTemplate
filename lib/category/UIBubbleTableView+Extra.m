//
//  UIBubbleTableView+Extra.m
//  Shogun
//
//  Created by scubism on 13/06/27.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UIBubbleTableView+Extra.h"

@implementation UIBubbleTableView (Extra)

-(void)scrollToBottom;
{
    if(self.contentSize.height < self.bounds.size.height){
        return;
    }
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        [self setContentOffset:bottomOffset animated:NO];
    }];
}

@end
