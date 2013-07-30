//
//  NSManagedObjectContextExtra.m
//  iPadPosDemo
//
//  Created by システム管理者 on 12/01/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContextExtra.h"

NSString * const NSManagedObjectContextThreadKey = @"NSManagedObjectContextThreadKey";

@interface NSManagedObjectContext ()
- (void)managedObjectContextDidSave:(NSNotification*)notification;
@end

@implementation NSManagedObjectContext (Extras)

+ (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread {
    NSMutableDictionary *threadDictionary = [thread threadDictionary];
    NSManagedObjectContext *context = [threadDictionary objectForKey:NSManagedObjectContextThreadKey];
    
    if (!context) {
#ifdef TARGET_OS_IPHONE
        id appDelegate = [[UIApplication sharedApplication] delegate];
#else
        id appDelegate = [NSApp delegate];
#endif
        NSManagedObjectContext *mainContext = [appDelegate managedObjectContext];
        
        if ([[NSThread currentThread] isMainThread]) {
            context = mainContext;
        } else {
            context = [[NSManagedObjectContext alloc] init];
            [context setPersistentStoreCoordinator:[mainContext persistentStoreCoordinator]];
        }
        
        [threadDictionary setObject:context forKey:NSManagedObjectContextThreadKey];
    }
    
    return context;
}

+ (NSManagedObjectContext *)managedObjectContextForCurrentThread {
    return [NSManagedObjectContext managedObjectContextForThread:[NSThread currentThread]];
}

+ (NSManagedObjectContext *)managedObjectContextForMainThread {
    return [NSManagedObjectContext managedObjectContextForThread:[NSThread mainThread]];
}

+ (BOOL)save:(NSError **)error {
    NSManagedObjectContext *context = [NSManagedObjectContext managedObjectContextForCurrentThread];
    BOOL isMainThread = [[NSThread currentThread] isMainThread];
    
    if (!isMainThread) {
        [[NSNotificationCenter defaultCenter] addObserver:context
                                                 selector:@selector(managedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:context];
    }
    
    BOOL result = [context save:error];
    
    if (!isMainThread) {
        [[NSNotificationCenter defaultCenter] removeObserver:context
                                                        name:NSManagedObjectContextDidSaveNotification 
                                                      object:context];
    }
    
    return result;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)managedObjectContextDidSave:(NSNotification*)notification {
    NSManagedObjectContext *context = [NSManagedObjectContext managedObjectContextForMainThread];
    
    [context performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                              withObject:notification
                           waitUntilDone:YES];
}
#pragma clang diagnostic pop
@end
