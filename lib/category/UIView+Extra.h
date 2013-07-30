//
//  UIView+Extra.h
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

enum kDirection{
    kDirectionNone = 0,
    kDirectionNext = 1,
    kDirectionPrev = -1,
};

-(void)setXPosition:(CGFloat)x;
-(void)setYPosition:(CGFloat)y;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;
-(void)nextInputView:(UIView*)inputView direction:(NSInteger)direction;
- (UIImage *)screenCapture;//自身のスクショを取る
-(NSString*)showHexAtPoint:(CGPoint)point;//指定した位置の色を取る
@end
