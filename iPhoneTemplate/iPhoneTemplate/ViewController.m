//
//  ViewController.m
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "ViewController.h"
#import "Category.h"
#import "TwitterTestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendRequest];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark --ButtonAction
-(IBAction)buttonDidPush:(id)sender{
    TwitterTestViewController* viewController = [[TwitterTestViewController alloc]initWithNibName:@"TwitterTestViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --Request
-(void)sendRequest{
    
    NSString *strURL = [NSString stringWithFormat:@"%@/api/W0001.php",WEB_URL];
    R9HTTPRequest *HTTPRequest = [[R9HTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [HTTPRequest setHTTPMethod:@"POST"];
    
    // Add body
    [HTTPRequest addBody:[Global currentUdid] forKey:@"udid"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];

    //    [dic setObject:order_id forKey:@"vc_order_id"];
    //    [dic setObject:customer_id forKey:@"vc_customer_id"];
    //    [dic setObject:shop_id forKey:@"vc_shop_id"];
    
    NSString* jsonString =[dic JSONRepresentation];
    DebugLog(@"%@",jsonString)
    //[HTTPRequest addBody:jsonString forKey:@"data"];
//    [HTTPRequest addBody:@"category" forKey:@"table"];
    // 通信が正常終了した際の処理
    [HTTPRequest setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"responseString : %@", responseString);
        
        if(responseString !=nil){
            id json=[responseString JSONValue];
            if(json==nil){
                return;
            }
            DebugLog(@"%@",[json description])

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCategoriesWidthArray:[json objectForKey:@"category"]];
            });
     
        }
  
    }];
    
    // 通信エラー時の処理
    [HTTPRequest setFailedHandler:^(NSError* error){

    }];
    
    [HTTPRequest setUploadProgressHandler:^(float newProgress){

    }];

    if ([HTTPRequest startRequest] == NO) {

    }
}
-(void)setCategoriesWidthArray:(NSArray*)dataArray
{

    NSManagedObjectContext* managedContext=[NSManagedObjectContext managedObjectContextForCurrentThread];
        [XMDataManager deleteAllRecordWithName:@"Category" managedContext:managedContext];

    NSDateFormatter *fmat=[[NSDateFormatter alloc] init];
    [fmat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int i=0; i<[dataArray count]; i++) {
        NSDictionary* aDic=[dataArray objectAtIndex:i];
        Category *cate=nil;

        int category_id=[[aDic objectForKey:@"category_id"] intValue];
        NSPredicate* pred=[NSPredicate predicateWithFormat:@"category_id=%d",category_id];
        NSArray* aArray=[XMDataManager getDataListFrom:@"Category" sort:nil pred:pred limit:0 managedContext:managedContext];
        if([aArray count]==0){

            cate=[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedContext];
        }else{
            cate=[aArray objectAtIndex:0];
        }

        cate.category_name=[aDic objectForKey:@"category_name"];
        cate.category_id=[NSNumber numberWithInt:[[aDic objectForKey:@"category_id"] intValue]];
        cate.level=[NSNumber numberWithInt:[[aDic objectForKey:@"level"] intValue]];
    }
    NSError *error = nil;
    [NSManagedObjectContext save:&error];
    
    fmat=nil;
    managedContext=nil;

}
@end
