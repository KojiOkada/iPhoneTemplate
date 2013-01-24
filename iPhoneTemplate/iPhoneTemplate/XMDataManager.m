//
//  XMMenuModelCollection.m
//  FreeHand
//

//

#import "XMDataManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContextExtra.h"

@implementation XMDataManager

static XMDataManager* sharedInstance = nil;

+(XMDataManager*)sharedManager{
    
    if(!sharedInstance){
        sharedInstance = [[XMDataManager alloc]init];
    }
    
    
    return sharedInstance;
}

-(id)init{
    
    self = [super init];
    if(!self){
        return nil;
    }
    
    return self;
}

+(NSManagedObjectContext *)managedObjectContext{
        
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        return delegate.managedObjectContext;
    }
    
    +(NSArray *)getDataListFrom:(NSString *)entityName
sort:(NSSortDescriptor *)sort
pred:(NSPredicate *)pred
limit:(int)limit
    {
        
        NSManagedObjectContext* managedObjectContex=[NSManagedObjectContext managedObjectContextForCurrentThread];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 取得するエンティティを設定
        NSEntityDescription *entityDescription;
        entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContex];
        [fetchRequest setEntity:entityDescription];
        if(sort!=nil){
            NSArray *sortDescriptors;
            
            sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }else{
            NSArray *sortDescriptors;
            sortDescriptors = [[NSArray alloc] initWithObjects: nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        
        // 取得条件の設定
        if(pred!=nil)[fetchRequest setPredicate:pred];
        
        // 取得最大数の設定
        if(limit>0)[fetchRequest setFetchBatchSize:limit];
        
        // データ取得用コントローラを作成
        NSFetchedResultsController *resultsController;
        
        resultsController = [[NSFetchedResultsController alloc]
                             initWithFetchRequest:fetchRequest
                             managedObjectContext:managedObjectContex
                             sectionNameKeyPath:nil
                             cacheName:entityName];
        
        // DBから値を取得する
        NSError* error = nil;
        if (![resultsController performFetch:&error]) {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        NSArray *result = resultsController.fetchedObjects ;
        resultsController=nil;
        
        managedObjectContex=nil;
        
        return result;
    }
    
    +(NSUInteger)getCountFrom:(NSString *)entityName pred:(NSPredicate *)pred managedContext:managedContextForThread{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 取得するエンティティを設定
        NSEntityDescription *entityDescription;
        entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedContextForThread];
        [fetchRequest setEntity:entityDescription];
        [fetchRequest setIncludesSubentities:NO];
        
        // 取得条件の設定
        if(pred!=nil)[fetchRequest setPredicate:pred];
        
        NSError* error = nil;
        NSUInteger count = [managedContextForThread countForFetchRequest:fetchRequest error:&error];
        
        if(count == NSNotFound){
            count = 0;
        }
        return count;
    }
    +(NSArray *)getDataListFrom:(NSString *)entityName
sort:(NSSortDescriptor *)sort
pred:(NSPredicate *)pred
limit:(int)limit managedContext:managedContextForThread
    {
        
        //NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 取得するエンティティを設定
        NSEntityDescription *entityDescription;
        entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedContextForThread];
        [fetchRequest setEntity:entityDescription];
        if(sort!=nil){
            NSArray *sortDescriptors;
            //sortDescriptors = [[[NSArray alloc] initWithObjects:sort, nil] autorelease];
            sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }else{
            NSArray *sortDescriptors;
            sortDescriptors = [[NSArray alloc] initWithObjects: nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        
        // 取得条件の設定
        if(pred!=nil)[fetchRequest setPredicate:pred];
        
        // 取得最大数の設定
        if(limit>0)[fetchRequest setFetchBatchSize:limit];
        
        // データ取得用コントローラを作成
        NSFetchedResultsController *resultsController;
        
        resultsController = [[NSFetchedResultsController alloc]
                             initWithFetchRequest:fetchRequest
                             managedObjectContext:managedContextForThread
                             sectionNameKeyPath:nil
                             cacheName:entityName];
        
        // DBから値を取得する
        NSError* error = nil;
        if (![resultsController performFetch:&error]) {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        NSArray *result = resultsController.fetchedObjects ;
        resultsController=nil;
        
        return result;
    }
    
+(NSArray *)getDataListFrom:(NSString *)entityName sort:(NSSortDescriptor *)sort
pred:(NSPredicate *)pred offset:(NSUInteger)offset limit:(NSUInteger)limit managedContext:managedContextForThread
    {
        //DebugLog(@"limit:%d offset:%d",limit,offset)
        
        //    if(limit < 0){
        //        DebugLog(@"fetch error limit is invalid")
        //        return nil;
        //    }
        //
        //    if(offset < 0){
        //        DebugLog(@"fetch error offset is invalid")
        //        return nil;
        //    }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 取得するエンティティを設定
        NSEntityDescription *entityDescription;
        entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedContextForThread];
        [fetchRequest setEntity:entityDescription];
        if(sort!=nil){
            NSArray *sortDescriptors;
            sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        // 取得条件の設定
        if(pred!=nil){
            [fetchRequest setPredicate:pred];
        }
        
        // 取得最大数の設定
        [fetchRequest setFetchBatchSize:limit];
        [fetchRequest setFetchLimit:limit];
        [fetchRequest setFetchOffset:offset];
        
        // データ取得用コントローラを作成
        NSFetchedResultsController *resultsController;
        
        resultsController = [[NSFetchedResultsController alloc]
                             initWithFetchRequest:fetchRequest
                             managedObjectContext:managedContextForThread
                             sectionNameKeyPath:nil
                             cacheName:entityName];
        
        // DBから値を取得する
        NSError* error = nil;
        if (![resultsController performFetch:&error]) {
            abort();
        }
        
        NSArray *result = resultsController.fetchedObjects ;
        //DebugLog(@"fetchCount:%d",[result count])
        resultsController=nil;
        
        return result;
    }
    
    
+(void)deleteAllRecordWithName:(NSString*)ename managedContext:managedContextForThread{
        
        @autoreleasepool {
            
            NSArray *arr = [XMDataManager getDataListFrom:ename sort:nil pred:nil limit:0 managedContext:managedContextForThread];
            for (int i=0; i<[arr count]; i++) {
                NSManagedObject *mo=[arr objectAtIndex:i];
                [managedContextForThread deleteObject:mo];
            }
            NSError *error = nil;
            [NSManagedObjectContext save:&error];
            if (error) {
                NSLog(@"DELETE ERROR: %@", error);
            } else {
                //NSLog(@"DELETED - %@", ename);
            }
            arr=nil;
        }
}
    
+(void)showEntityArray:(NSArray *)arr{
        for (int i=0; i<[arr count]; i++) {
            NSManagedObject *obj=[arr objectAtIndex:i];
            NSDictionary *prop=[obj.entity attributesByName];
            NSLog(@"%@",obj.entity.name);
            for (id e in prop){
                NSLog(@"	%@ : %@",e,[obj valueForKey:e]);
            }
        }
}
#pragma mark --userMethod--
-(void)removeFile:(NSString *)fileName{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *filePaths =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir =[filePaths objectAtIndex:0];
	NSString *toPath =
	[documentDir stringByAppendingPathComponent:fileName];
	DebugLog(@"toPath = %@",toPath)
	[fileManager removeItemAtPath:toPath error:nil];
	
}

@end
