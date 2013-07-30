//
//  UIButton+Extra.m
//  Shogun
//
//  Created by システム管理者 on 13/07/01.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UIButton+Extra.h"

@implementation UIButton(Extra)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setRemoteImageWithPath:(NSString*)imagePath{
    dispatch_queue_t q_global, q_main;
    q_global = dispatch_get_global_queue(0, 0);
    q_main = dispatch_get_main_queue();
    
    dispatch_async(q_global, ^{
        
        UIActivityIndicatorView *indicator;
        indicator = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = self.bounds;
        indicator.hidesWhenStopped = TRUE;
        indicator.contentMode = UIViewContentModeCenter;
        [indicator startAnimating];
        
        dispatch_async(q_main, ^{
            [self setImage:nil forState:UIControlStateNormal];
            [self addSubview:indicator];
        });
        
        NSURL *smallImageURL = [NSURL URLWithString:imagePath];
        NSData *smallImageData = [NSData dataWithContentsOfURL:smallImageURL];
        UIImage *image = [UIImage imageWithData:smallImageData];
        
        dispatch_async(q_main, ^{
            [self setImage:image forState:UIControlStateNormal];
            [indicator removeFromSuperview];
        });
    });
}
-(void)setRemoteBackGroundImageWithPath:(NSString*)imagePath{
    dispatch_queue_t q_global, q_main;
    q_global = dispatch_get_global_queue(0, 0);
    q_main = dispatch_get_main_queue();
    
    dispatch_async(q_global, ^{
        
        UIActivityIndicatorView *indicator;
        indicator = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = self.bounds;
        indicator.hidesWhenStopped = TRUE;
        indicator.contentMode = UIViewContentModeCenter;
        [indicator startAnimating];
        
        dispatch_async(q_main, ^{
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            [self addSubview:indicator];
        });
        
        NSURL *smallImageURL = [NSURL URLWithString:imagePath];
        NSData *smallImageData = [NSData dataWithContentsOfURL:smallImageURL];
        UIImage *image = [UIImage imageWithData:smallImageData];
        
        dispatch_async(q_main, ^{
            [self setBackgroundImage:image forState:UIControlStateNormal];
            [indicator removeFromSuperview];
        });
    });
}
@end
