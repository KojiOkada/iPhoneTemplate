//
//  UIColor+Extra.m
//
//

#import "UIColor+Extra.h"

@implementation UIColor (Extra)
+(UIColor*)colorFromHex:(NSString* )string{
    
    if(![string isKindOfClass:[NSString class]]){
        return [UIColor redColor];
    }
    UIColor *color;
    if (string && [string length] == 7) {
        NSString *colorString = [NSString stringWithFormat:
								 @"0x%@ 0x%@ 0x%@",
								 [string substringWithRange:NSMakeRange(1, 2)],
								 [string substringWithRange:NSMakeRange(3, 2)],
								 [string substringWithRange:NSMakeRange(5, 2)]];
        
        unsigned red, green, blue;
        NSScanner *scanner = [NSScanner scannerWithString:colorString];
        if ([scanner scanHexInt:&red] && [scanner scanHexInt:&green] && [scanner scanHexInt:&blue]) {
            color = [[UIColor alloc] initWithRed:(float)red / 0xff
                                           green:(float)green / 0xff
                                            blue:(float)blue / 0xff
                                           alpha:1.0];
        }
    }else if ([string length]==6){
        NSString *colorString = [NSString stringWithFormat:
								 @"0x%@ 0x%@ 0x%@",
								 [string substringWithRange:NSMakeRange(0, 1)],
								 [string substringWithRange:NSMakeRange(2, 2)],
								 [string substringWithRange:NSMakeRange(4, 2)]];
        
        unsigned red, green, blue;
        NSScanner *scanner = [NSScanner scannerWithString:colorString];
        if ([scanner scanHexInt:&red] && [scanner scanHexInt:&green] && [scanner scanHexInt:&blue]) {
            color = [[UIColor alloc] initWithRed:(float)red / 0xff
                                           green:(float)green / 0xff
                                            blue:(float)blue / 0xff
                                           alpha:1.0];
            
        }
    }
    return color;
}
@end
