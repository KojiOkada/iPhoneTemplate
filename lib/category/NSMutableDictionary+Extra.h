//
//  NSMutableDictionary+Extra.h
//  iPadPosDemo
//
//  Created by scubism on 13/06/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extra)

-(void)addObject:(id)anObject forKey:(id <NSCopying>)aKey;
-(void)setDate:(NSDate*)anObject forKey:(id <NSCopying>)aKey;
-(void)setNumber:(NSNumber*)anObject forKey:(id <NSCopying>)aKey validZero:(BOOL)validZero;
-(void)setString:(NSString*)anObject forKey:(id <NSCopying>)aKey;

@end
