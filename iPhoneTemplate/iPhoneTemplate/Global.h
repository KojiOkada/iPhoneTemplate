//
//  Global.h
//




@interface UIViewController (Extras)

-(void)showIndicator:(UIViewController*)viewcontroller;


@end
@interface NSString (Extras)
+(NSDate*)dateFromString:(NSString*)dateString;
+(NSString *)stringFromDate:(NSDate*)date;
+(NSString *)stringFromNumberInt:(int)num;
+(NSString *)stringFromNumberDouble:(double)num;
+(NSString *)stringFromNumberLongLong:(long long)num;
- (NSString*) stringTrim;// スペース、改行除去
- (NSString*) stringToFullwidth;// 半角→全角
- (NSString*) stringToHalfwidth;// 全角→半角
- (NSString*) stringKatakanaToHiragana;// カタカナ→ひらがな
- (NSString*) stringHiraganaToKatakana;// ひらがな→カタカナ
- (NSString*) stringHiraganaToLatin;// ひらがな→ローマ字
- (NSString*) stringLatinToHiragana;// ローマ字→ひらがな
- (NSString*) stringKatakanaToLatin;// カタカナ→ローマ字
- (NSString*) stringLatinToKatakana;// ローマ字→カタカナ
@end;

@interface NSMutableArray (Extras)
-(BOOL)addObjectIfNotExists:(id)e;
@end;


@interface Global : NSObject {

}

+ (void)blinkImage:(UIView *)target;

+ (NSDate *)addMonth:(NSDate *) baseDate addCount:(int)addCount;

+ (NSDate *)getFirstDate:(NSDate *)baseDate;


+(UIBarStyle)commonBarStyle;

+(NSString *)urlencode:(NSString *)plainString;
+(NSString *)urldecode:(NSString *)escapedUrlString;
+(NSString *)currentUdid;
+(UIColor*)colorFromHex:(NSString*)string;

//+(BOOL)isDigit:(NSString *)text;

+ (NSString *)getHourMinuteFromDate:(NSDate *)inDate;
+(void)alignLeftForNavigationTitle:(UIViewController *)view;
+(UIColor *)getBaseFontColor;


+(void)storeAccessToken:(NSString *)accessToken;

+(UIView *)getBaseViewForHeaderInSection:(NSString *)sectionTitle;
@end

