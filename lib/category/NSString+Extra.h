//
//  NSString+Extra.h
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extra)
+(NSString*)stringFromDate:(NSDate*)date;
+(NSString*)createUid;
+(NSString *)stringFromNumberInt:(int)num;
+(NSString *)stringFromNumberDouble:(double)num;
+(NSString *)stringFromNumberLongLong:(long long)num;
-(NSNumber*)numberValue;
-(NSDate*)dateValue;
-(NSString*)stringToCurrency;
- (NSString*) stringTrim;// スペース、改行除去
- (NSString*) stringToFullwidth;// 半角→全角
- (NSString*) stringToHalfwidth;// 全角→半角
- (NSString*) stringKatakanaToHiragana;// カタカナ→ひらがな
- (NSString*) stringHiraganaToKatakana;// ひらがな→カタカナ
- (NSString*) stringHiraganaToLatin;// ひらがな→ローマ字
- (NSString*) stringLatinToHiragana;// ローマ字→ひらがな
- (NSString*) stringKatakanaToLatin;// カタカナ→ローマ字
- (NSString*) stringLatinToKatakana;// ローマ字→カタカナ
-(NSString *)entityReference;
- (NSString *)encodeURIComponentByEncoding:(NSStringEncoding)encoding;

@end;