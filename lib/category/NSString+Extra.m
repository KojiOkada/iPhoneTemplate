//
//  NSString+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import "NSString+Extra.h"

@implementation NSString (Extra)
+(NSString*)stringFromDate:(NSDate*)date{
    
    if(!date){
        return nil;
    }
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:date];
}
+(NSString*)createUid{
    // 識別子を作成する
    CFUUIDRef uuid;
    uuid = CFUUIDCreate(NULL);
    NSString *_identifier = (__bridge NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return _identifier;
}
+(NSString *)stringFromNumberInt:(int)num{
    
	NSNumber *number = [[NSNumber alloc] initWithInt:num];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumIntegerDigits:10];
    [fmt setGroupingSeparator:@","];
    [fmt setGroupingSize:3];
	
	return [fmt stringForObjectValue:number];
}
+(NSString *)stringFromNumberDouble:(double)num{
    
	NSNumber *number = [[NSNumber alloc] initWithDouble:num];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumIntegerDigits:10];
    [fmt setGroupingSeparator:@","];
    [fmt setGroupingSize:3];
	
	return [fmt stringForObjectValue:number];
}
+(NSString *)stringFromNumberLongLong:(long long)num{
    
	NSNumber *number = [[NSNumber alloc] initWithLongLong:num];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumIntegerDigits:10];
    [fmt setGroupingSeparator:@","];
    [fmt setGroupingSize:3];
	
	return [fmt stringForObjectValue:number];
}

-(NSNumber*)numberValue
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    return [fmt numberFromString:self];
}

-(NSDate*)dateValue;
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ja"]];
    [fmt setTimeZone:[NSTimeZone systemTimeZone]];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [fmt dateFromString:self];
}

-(NSString*)stringToCurrency;
{
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setPositiveFormat:@"¥ #,##0"];
    [currencyFormatter setNegativeFormat:@"¥-#,##0"];
    
    return [currencyFormatter stringFromNumber:price];
}

- (NSString *)stringTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*) stringTransformWithTransform:(CFStringRef)transform reverse:(Boolean)reverse {
    NSMutableString* retStr = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((CFMutableStringRef)retStr, NULL, transform, reverse);
    return retStr;
}

- (NSString*) stringToFullwidth {
    return [self stringTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                      reverse:true];
}

- (NSString*) stringToHalfwidth {
    return [self stringTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                      reverse:false];
}

- (NSString*) stringKatakanaToHiragana {
    return [self stringTransformWithTransform:kCFStringTransformHiraganaKatakana
                                      reverse:true];
}

- (NSString*) stringHiraganaToKatakana {
    return [self stringTransformWithTransform:kCFStringTransformHiraganaKatakana
                                      reverse:false];
}

- (NSString*) stringHiraganaToLatin {
    return [self stringTransformWithTransform:kCFStringTransformLatinHiragana
                                      reverse:true];
}

- (NSString*) stringLatinToHiragana {
    return [self stringTransformWithTransform:kCFStringTransformLatinHiragana
                                      reverse:false];
}

- (NSString*) stringKatakanaToLatin {
    return [self stringTransformWithTransform:kCFStringTransformLatinKatakana
                                      reverse:true];
}

- (NSString*) stringLatinToKatakana {
    return [self stringTransformWithTransform:kCFStringTransformLatinKatakana
                                      reverse:false];
}

-(NSString *)entityReference
{
    NSMutableString *mStr = [NSMutableString stringWithString:self];
    [mStr replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [mStr length])];
    [mStr replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [mStr length])];
    [mStr replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [mStr length])];
    [mStr replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:NSMakeRange(0, [mStr length])];
    [mStr replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [mStr length])];
    return mStr;
}

- (NSString *)encodeURIComponentByEncoding:(NSStringEncoding)encoding{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end


