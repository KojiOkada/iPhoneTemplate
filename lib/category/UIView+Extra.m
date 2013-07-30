//
//  UIView+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

-(void)setXPosition:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
}
-(void)setYPosition:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width,self.frame.size.height);
}
-(void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
-(void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(void)nextInputView:(UIView*)inputView direction:(NSInteger)direction
{
    __block int _direction = direction;
    int (^nextTag)(int) = ^(int tag){
        if(_direction == kDirectionNext) return tag+1;
        if(_direction == kDirectionPrev) return tag-1;
        return 0;
    };
    
    NSInteger tag = nextTag(inputView.tag);
    UIView *view;
    while (TRUE) {
        view = [self viewWithTag:tag];
        if(view == nil){
            break;
        }
        if(view.hidden == NO && ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])){
            [view becomeFirstResponder];
            break;
        }
        tag = nextTag(view.tag);
    }
    [inputView resignFirstResponder];
}

- (UIImage *)screenCapture {
    
	UIImage *capture;
	//CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect rect = self.frame;
    //CGRect rect = imageView.bounds;
    
	UIGraphicsBeginImageContext(rect.size);
	[[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
	capture = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
//    DebugLog(@"%@",NSStringFromCGSize(rect.size))
	return capture;
}

//指定した位置の色情報を取得する。
-(NSString*)showHexAtPoint:(CGPoint)point{
	
    UIImage *origin = [self screenCapture];
    CGImageRef wholeImageRef = [origin CGImage];
    
	CGRect rect = CGRectMake(point.x, point.y, 1, 1); // 真ん中部分を切り抜く
	CGImageRef partImageRef = CGImageCreateWithImageInRect(wholeImageRef, rect);
	UIImage *img = [UIImage imageWithCGImage:partImageRef];
	CGImageRelease(partImageRef);
	
    CGImageRef  cgImage;
    cgImage = img.CGImage;
	
    size_t                  width;
    size_t                  height;
    size_t                  bytesPerRow;
    
    width = CGImageGetWidth(cgImage);
    height = CGImageGetHeight(cgImage);
    bytesPerRow = CGImageGetBytesPerRow(cgImage);
	
	// データプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(cgImage);
	
    // ビットマップデータを取得する
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
	NSMutableString *colorHex;
	NSUInteger  i, j;

    for (j = 0; j < height; j++) {
        for (i = 0; i < width; i++) {
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
			
            // RGBの値を取得する
            UInt8   r, g, b;
            b = *(tmp + 0);
            g = *(tmp + 1);
            r = *(tmp + 2);

            colorHex = [NSString stringWithFormat:@"#%02x%02x%02x",r,g,b];
            
        }
    }
	CGDataProviderRelease(data);
    
    return colorHex;
}
@end
