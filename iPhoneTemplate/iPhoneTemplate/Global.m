
//
//  Global.m
//  KurokawaTecho
//
//  Created by hashi on 11/03/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContextExtra.h"


/*
@interface UITableView (Extras)
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
@end;

@implementation UITableView (Extras)
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
	NSLog(@"init");
}
@end
*/

@implementation UIViewController (Extras)

-(void)showIndicator:(UIViewController*)viewcontroller{
    
    UIView *clearView = [[UIView alloc]initWithFrame:viewcontroller.view.frame];
    [clearView setBackgroundColor:[UIColor blackColor]];
    clearView.alpha = 0.8f;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = clearView.center;
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,150, 80)];
    message.text = @"読み込み中";
    message.adjustsFontSizeToFitWidth = YES;
    
    message.center = indicator.center;
    
    
    [clearView addSubview:indicator];
    [viewcontroller.view addSubview:clearView];
    [indicator startAnimating];
}

@end
@implementation NSString (Extras)
+(NSDate*)dateFromString:(NSString*)dateString{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:00"];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *dte = [dateFormat dateFromString:dateString];
    
    return dte;
}
+(NSString*)stringFromDate:(NSDate*)date{
    
    if(!date){
        return nil;
    }
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:00";
    return [df stringFromDate:date];
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

- (NSString *)stringTrim{
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

@end



@implementation NSMutableArray (Extras)

-(BOOL)addObjectIfNotExists:(id)e{
    if (e==nil) {
        return NO;
    }
    
    for (int i=0; i<[self count]; i++) {
        if ([self objectAtIndex:i]==e) {
            return NO;
        }
    }
    
    [self addObject:e];
    return YES;
}

@end

@implementation Global

+(UIColor*)colorFromHex:(NSString*)string{
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
    }else if(string && [string length] == 6){
        
        NSString *colorString = [NSString stringWithFormat:
								 @"0x%@ 0x%@ 0x%@",
								 [string substringWithRange:NSMakeRange(0, 2)],
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

#pragma mark - Loading Mask Methods

+ (void)blinkImage:(UIView *)target {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1.0f;
    animation.repeatCount = HUGE_VAL;
    animation.values = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithFloat:1.0f],
                        [NSNumber numberWithFloat:0.0f],
                        [NSNumber numberWithFloat:1.0f],
                        nil];
    [target.layer addAnimation:animation forKey:@"blink"];
}


+ (NSDate *)addMonth:(NSDate *) baseDate
            addCount:(int) addCount{
    NSUInteger flags =  NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar* cal = [NSCalendar currentCalendar];
    
    NSDateComponents* cmp = [cal components:flags fromDate:baseDate];
    
    int dayPoint = [cmp day];
    
    [cmp setMonth:[cmp month]+addCount];
    
    NSDate* ret = [cal dateFromComponents:cmp];
    
    cmp = [cal components:flags fromDate:ret];
	
    
    if (dayPoint != [cmp day]){
		//fret=(NSDate *)[ret addTimeInterval:60.0f * 60 * 24 * -[cmp day]];
        //return (NSDate *)[ret addTimeInterval:60.0f * 60 * 24 * -[cmp day]];
    }
    
    return ret;
}
+ (NSDate *)getFirstDate:(NSDate *)baseDate{
	
    NSDate *date=[NSDate date];

	NSDateFormatter *fmat=[[NSDateFormatter alloc] init];
	[fmat setDateFormat:@"YYYY-MM"];
	NSString *dstr=[fmat stringFromDate:date];
	dstr=[NSString stringWithFormat:@"%@-02",dstr];
	[fmat setDateFormat:@"YYYY-MM-dd"];
	return [fmat dateFromString:dstr];
}

+(UIBarStyle)commonBarStyle{
    
    return UIBarStyleDefault;
}

+(NSString *)urlencode:(NSString *)plainString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)plainString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

+(NSString *)urldecode:(NSString *)escapedUrlString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)escapedUrlString,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}

+(NSString *)currentUdid{
    NSString *udid=[UIDevice currentDevice].uniqueIdentifier;
    return udid;
}


// NSDate から Hour:Minute を取得する
+ (NSString *)getHourMinuteFromDate:(NSDate *)inDate
{
    if (!inDate) {
        return nil;
    }
    DebugLog(@"%@", inDate)
    
    // 出力書式
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:kCFCalendarUnitDay
                                                       | kCFCalendarUnitHour
                                                       | kCFCalendarUnitMinute
                                              fromDate:inDate];
    
    NSString *hour = [NSString stringWithFormat:@"%02d", dateComps.hour];
    NSString *minute = [NSString stringWithFormat:@"%02d", dateComps.minute];
    
    NSString *convertedString = [NSString stringWithFormat:@"%@:%@", hour, minute];
    DebugLog(@"%@", convertedString)
    
    return convertedString;
}

+(void)alignLeftForNavigationTitle:(UIViewController *)view{
    // NavigationBarのラベル位置を左寄せにする
    UIView *mCustView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    UILabel *mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 13, 200, 30)];
    mTextLabel.backgroundColor = [UIColor clearColor];
    mTextLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:17.0];
    mTextLabel.textColor = [Global getBaseFontColor];
    mTextLabel.text = view.title;
    [mCustView addSubview:mTextLabel];
    view.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mCustView];
    view.title = @"";
}

+(UIColor *)getBaseFontColor{
    return [UIColor colorWithWhite:0.196f alpha:1.0f];
}

+(void)storeAccessToken:(NSString *)accessToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:accessToken forKey:@"ACCESS_TOKEN"];
    [ud synchronize];
}

+(UIView *)getBaseViewForHeaderInSection:(NSString *)sectionTitle {
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UIView *mCustView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 495, 23)];
    mCustView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 495, 21)];
    imageView.image = [UIImage imageNamed:@"bg_headline_small.png"];
    UILabel *mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 6, 200, 21)];
    mTextLabel.backgroundColor = [UIColor clearColor];
    mTextLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0];
    mTextLabel.textColor = [UIColor whiteColor];
    mTextLabel.text = sectionTitle;
    [mCustView addSubview:imageView];
    [mCustView addSubview:mTextLabel];
    
    return mCustView;
}
@end
