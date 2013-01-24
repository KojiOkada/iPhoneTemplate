//
//  Category.m
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "Category.h"


@implementation Category

@dynamic category_id;
@dynamic category_name;
@dynamic create_date;
@dynamic level;

-(void)updateWithDictionary:(NSDictionary *)dict {
    NSDateFormatter *fmat = [[NSDateFormatter alloc] init];
    [fmat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.category_name = [dict objectForKey:@"category_name"];
    self.category_name = [dict objectForKey:@"category_name"];
    self.category_id = [NSNumber numberWithInt:[[dict objectForKey:@"category_id"] intValue]];
    self.level = [NSNumber numberWithInt:[[dict objectForKey:@"level"] intValue]];
}

@end
