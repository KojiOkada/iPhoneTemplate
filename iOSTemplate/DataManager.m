//
//  DataManager.m
//  BodyConditionsAssessment
//
//  Created by Koji_Okada on 13/07/19.
//
//

#import "DataManager.h"

@implementation DataManager

static DataManager *DataManagerInstance = nil;

+ (DataManager *)sharedDataManager;
{
    @synchronized(self) {
        static dispatch_once_t pmanager;
        dispatch_once(&pmanager, ^{ DataManagerInstance = [[self alloc] init]; });
    }
    return DataManagerInstance;
}

-(void)loadSickDetailData;
{
    [SVProgressHUD show];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sick_detail" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments
                                                error:&error];
    LOG(@"json = %@",json);
    
    [MagicalRecord setupCoreDataStack];

    
    [Sick_detail deleteAllMatchingPredicate:nil];
    
    if([json[@"sick_details"] isKindOfClass:[NSArray class]]){
        [json[@"sick_details"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Sick_detail *sickDetail = [Sick_detail MR_createEntity];
            sickDetail.sick_detail_id = @([obj[@"sick_detail_id"] integerValue]);
            sickDetail.cation_text = obj[@"cation_text"];
            sickDetail.assessment_text = obj[@"assessment_text"];
            sickDetail.commentary_text = obj[@"commentary_text"];
        }];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    [SVProgressHUD dismiss];
}

-(void)loadSickData;
{
    [SVProgressHUD show];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sick" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments
                                                error:&error];
    LOG(@"json = %@",json);
    
    [MagicalRecord setupCoreDataStack];
    
    [Sick deleteAllMatchingPredicate:nil];

    if([json[@"sicks"] isKindOfClass:[NSArray class]]){
        [json[@"sicks"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Sick *sick = [Sick MR_createEntity];
            sick.sick_id = @(idx);
            sick.sick_detail_id = @([obj[@"sick_detail_id"] integerValue]);
            sick.first_category_name = obj[@"first_category_name"];
            sick.second_category_name = obj[@"second_category_name"];
            sick.name = obj[@"name"];
        }];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    [SVProgressHUD dismiss];
    [[DataManager sharedDataManager] loadSickDetailData];
}

-(NSMutableArray*)secondCategories:(NSString*)firstCategoryName;
{
    NSArray *array = [Sick findAllSortedBy:@"sick_id" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"first_category_name = %@", firstCategoryName]];
    return [[array valueForKeyPath:@"@distinctUnionOfObjects.second_category_name"] mutableCopy];
}

-(NSMutableArray*)sicksWithFirstCategoryName:(NSString*)firstCategoryName;
{
    NSArray *array = [Sick findAllSortedBy:@"sick_id" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"first_category_name = %@", firstCategoryName]];
    return [array mutableCopy];
}

-(NSMutableArray*)sicksWithFirstCategoryName:(NSString*)firstCategoryName secondCategoryName:(NSString*)secondCategoryName;
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"first_category_name = %@ AND second_category_name = %@", firstCategoryName, secondCategoryName];
    NSArray *array = [Sick findAllSortedBy:@"sick_id" ascending:YES withPredicate:pred];
    return [array mutableCopy];
}

-(NSMutableArray*)sicksWithPrefix:(NSString*)prefix;
{
    NSArray *array = [Sick findAllSortedBy:@"sick_id" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", prefix]];
    return [array mutableCopy];
}
-(NSString*)sickNameWithId:(NSString*)sickId{
    NSArray *array = [Sick findAllSortedBy:@"sick_id" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"sick_id = %@",sickId]];
    
    if([array count]==0){
        return @"";
    }else{
        Sick *sick = [array objectAtIndex:0];
        return sick.name;
    }
}
-(NSMutableDictionary*)sickDetail:(NSInteger)sickDetailId;
{
//    NSArray *array = [Sick_detail findByAttribute:@"sick_detail_id" withValue:@(sickDetailId)];
    // デモ用
    NSArray *array = [Sick_detail findAll];
    if([array count] > 0){
        int index = rand() % 3;
        NSManagedObject *managed = array[index];
        return [[managed dictionaryWithValuesForKeys:[[[managed entity] attributesByName] allKeys]] mutableCopy];
    }
    return nil;
}

@end
