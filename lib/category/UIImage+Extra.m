//
//  UIImage+Extra.m
//
//

#import "UIImage+Extra.h"
#import "NSData-Base64.h"
@implementation UIImage (Extra)

-(UIImage*)shrinkImage:(CGSize)size{

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    // UIGraphicsGetImageFromCurrentImageContextが呼ばれるまで
    // 描画はすべて新しい描画領域が対象となる。
    [self drawInRect:rect]; 

    UIImage* img= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return  img;
}
-(void)saveImage:(NSString*)path{
    
    NSData *data = [[NSData alloc]initWithData:UIImagePNGRepresentation(self)];
    
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
}

//画像の一部を切り抜く
-(UIImage*)partImage:(CGRect)rect{
	
    CGImageRef wholeImageRef = [self CGImage];
	CGImageRef partImageRef = CGImageCreateWithImageInRect(wholeImageRef, rect);
	UIImage *smallImage = [UIImage imageWithCGImage:partImageRef];
	CGImageRelease(partImageRef);
	
	return smallImage;
}
//-(NSString*)base64String{
//    CIImage *ciImage = [[CIImage alloc] initWithImage:self]; //ファイル名
//    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorMonochrome" //フィルター名
//                                    keysAndValues:kCIInputImageKey, ciImage,
//                          @"inputColor", [CIColor colorWithRed:0.75 green:0.75 blue:0.75], //パラメータ
//                          @"inputIntensity", [NSNumber numberWithFloat:1.0], //パラメータ
//                          nil
//                          ];
//    
//    CIContext *ciContext = [CIContext contextWithOptions:nil];
//    CGImageRef cgImage = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
//    
//    // 画像情報を取得する
//    size_t width = CGImageGetWidth(cgImage);
//    size_t height = CGImageGetHeight(cgImage);
//    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
//    
//    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);// データプロバイダを取得する
//    
//    // ビットマップデータを取得する
//    CFDataRef data = CGDataProviderCopyData(dataProvider);
//    UInt8* buffer = (UInt8*)CFDataGetBytePtr(data);
//    
//    NSMutableString *str = [[NSMutableString alloc]init];
//    NSMutableString *str2 = [[NSMutableString alloc]init];
//    NSUInteger  i, j;
//    
//    for (j = 0; j < height; j++) {
//        char buff[256];
//        for (i = 0; i < width; i++) {
//            char buff1[5];
//            
//            UInt8*  tmp;// ピクセルのポインタを取得する
//            tmp = buffer + j * bytesPerRow + i * 4;
//            int value = 0;
//            // RGBの値を取得する
//            UInt8 b = *(tmp + 0);
//            UInt8 g = *(tmp + 1);
//            UInt8 r = *(tmp + 2);
//            
//            if((r + g + b)==0){
//                value = 1;
//            }else{
//                value = 0;
//            }
//            
//            sprintf(buff1,"%d",value);
//            strcat(buff, buff1);
//            
//            if( i % 8 == 0 ){
//                char *p2;
//                long in_num = strtoul(buff, &p2, 2);
//                int num = (int)in_num;
//                [str appendFormat:@"%02x",num];
//                buff[0]=0;
//            }
//        }
//    }
//    CGDataProviderRelease(data);
//    
//    NSMutableData *commandToSend= [[NSMutableData alloc]init];
//    unsigned char whole_byte;
//    char byte_chars[3] = {'\0','\0','\0'};
//    int c;
//    for (c=0; c < [str length]/2; c++) {
//        
//        byte_chars[0] = [str characterAtIndex:c * 2];
//        byte_chars[1] = [str characterAtIndex:c * 2+1];
//        whole_byte = strtol(byte_chars, NULL, 16);
//        [commandToSend appendBytes:&whole_byte length:1];
//    }
//    
//    NSString *base64 = [commandToSend base64Encoding];
//    //DebugLog(@"FromData=%@",base64)
//    return base64;
//}
@end
