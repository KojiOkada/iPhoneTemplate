//
//  UIImageView+Extra.m
//  Shogun
//
//  Created by システム管理者 on 13/06/28.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "UIImageView+Extra.h"

@implementation UIImageView (Extra)

-(void)setRemoteImageWithPath:(NSString*)imagePath{
    
#warning バンドルされたイメージをムリヤリ取得
    NSString *imageName = [[imagePath componentsSeparatedByString:@"="] lastObject];
    UIImage *image = [UIImage imageNamed:imageName];
    if(image){
        CALayer *layer = [CALayer layer];
        layer.frame = self.bounds;
        layer.contents = (id)image.CGImage;
        [self.layer addSublayer:layer];
        return;
    }
    
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
            self.image = nil;
            [self addSubview:indicator];
        });
        
        NSURL *smallImageURL = [NSURL URLWithString:imagePath];
        NSData *smallImageData = [NSData dataWithContentsOfURL:smallImageURL];
        UIImage *image = [UIImage imageWithData:smallImageData];
        
        dispatch_async(q_main, ^{
            self.image = image;
            [indicator removeFromSuperview];
        });
    });
}


@end
