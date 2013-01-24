

#import <Foundation/Foundation.h>


@interface XMDataManager : NSObject{

}

+(XMDataManager*)sharedManager;
+(NSManagedObjectContext *)managedObjectContext;
+(NSUInteger)getCountFrom:(NSString *)entityName pred:(NSPredicate *)pred managedContext:managedContextForThread;
+(NSArray *)getDataListFrom:(NSString *)entityName
					   sort:(NSSortDescriptor *)sort
					   pred:(NSPredicate *)pred
					  limit:(int)limit;
+(NSArray *)getDataListFrom:(NSString *)entityName
					   sort:(NSSortDescriptor *)sort
					   pred:(NSPredicate *)pred
					  limit:(int)limit managedContext:managedContextForThread;

+(NSArray *)getDataListFrom:(NSString *)entityName
					   sort:(NSSortDescriptor *)sort
					   pred:(NSPredicate *)pred
                     offset:(NSUInteger)offset
					  limit:(NSUInteger)limit managedContext:managedContextForThread;

+(void)deleteAllRecordWithName:(NSString*)ename managedContext:managedContextForThread;
+(void)showEntityArray:(NSArray *)arr;

-(void)removeFile:(NSString *)fileName;
@end
