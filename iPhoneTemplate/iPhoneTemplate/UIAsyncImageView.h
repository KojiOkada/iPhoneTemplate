//
//  UIAsyncImageView.h
//  iPadPosDemo
//
//  Created by hashimoto0623 on 11/06/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface UIAsyncImageView : UIImageView {
@private
    NSURLConnection *conn;
    NSMutableData *data;
}
-(void)loadImage:(NSString *)url;
-(void)setStaticImage:(UIImage *)simage;
-(void)abort;
@end