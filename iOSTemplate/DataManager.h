//
//  DataManager.h
//  BodyConditionsAssessment
//
//  Created by Koji_Okada on 13/07/19.
//
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedDataManager;

-(void)loadSickData;
-(void)loadSickDetailData;

-(NSMutableArray*)secondCategories:(NSString*)firstCategoryName;
-(NSMutableArray*)sicksWithFirstCategoryName:(NSString*)firstCategoryName;
-(NSMutableArray*)sicksWithFirstCategoryName:(NSString*)firstCategoryName secondCategoryName:(NSString*)secondCategoryName;
-(NSMutableArray*)sicksWithPrefix:(NSString*)prefix;
-(NSString*)sickNameWithId:(NSString*)sickId;
-(NSMutableDictionary*)sickDetail:(NSInteger)sickDetailId;

@end
