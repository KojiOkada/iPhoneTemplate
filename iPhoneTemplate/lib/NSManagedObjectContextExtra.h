//
//  NSManagedObjectContext(Extra).h
//  iPadPosDemo
//
//  Created by システム管理者 on 12/01/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Extras)
+ (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;
+ (NSManagedObjectContext *)managedObjectContextForCurrentThread;
+ (NSManagedObjectContext *)managedObjectContextForMainThread;
+ (BOOL)save:(NSError **)error;
@end