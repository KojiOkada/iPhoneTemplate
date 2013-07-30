//
//  UIImage+Extra.h
//  FreeHand
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
@interface UIImage (Extra)
-(UIImage*)shrinkImage:(CGSize)size;
-(void)saveImage:(NSString*)path;
-(UIImage*)partImage:(CGRect)rect;//画像の一部を切り抜く
//-(NSString*)base64String;
@end
