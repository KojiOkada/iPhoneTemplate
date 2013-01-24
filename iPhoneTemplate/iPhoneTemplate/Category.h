//
//  Category.h
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSString * category_name;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSNumber * level;

@end

@interface Category (CoreDataGeneratedAccessors)

-(void)updateWithDictionary:(NSDictionary *)dict;

@end

