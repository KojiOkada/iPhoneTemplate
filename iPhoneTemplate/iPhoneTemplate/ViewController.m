//
//  ViewController.m
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//GraphAPIについて
//https://developers.facebook.com/docs/reference/api/

#import "ViewController.h"
#import "Category.h"
#import "TwitterTestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self sendRequest];
    
    [self updateView];

    _buttonLoginLogout.text = @"login";
    _buttonLoginLogout.backgroundColor = [UIColor blueColor];
    _buttonGetFriend.text = @"GetFriend";
    _buttonGetFriend.backgroundColor = [UIColor blueColor];
    _buttonTwitter.text = @"Twitter";
    _buttonTwitter.backgroundColor = [UIColor blueColor];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
   
}
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        _buttonLoginLogout.text = @"Log out";
        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",appDelegate.session.accessToken]];
    } else {
        // login-needed account UI is shown whenever the session is closed
        _buttonLoginLogout.text = @"Log in";
        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}
-(IBAction)getFriends:(id)sender{
     //[self getFBFriend];
    [self getMyInfo];
}
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark --ButtonAction
-(IBAction)buttonDidPush:(id)sender{
    TwitterTestViewController* viewController = [[TwitterTestViewController alloc]initWithNibName:@"TwitterTestViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark FB friends
-(void)getFBFriend{
  AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSString *strURL =[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",appDelegate.session.accessToken];
    
    R9HTTPRequest *HTTPRequest = [[R9HTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [HTTPRequest setHTTPMethod:@"GET"];
 
    [HTTPRequest setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"responseString : %@", responseString);
        
        if(responseString !=nil){
            id json=[responseString JSONValue];
            if(json==nil){
                return;
            }
            DebugLog(@"%@",[json description])
            NSArray *array = [json objectForKey:@"data"];
            DebugLog(@"count = %d",[array count])
            dispatch_async(dispatch_get_main_queue(), ^{
               
            });
            
        }
        
    }];
    
    if ([HTTPRequest startRequest] == NO) {
        
    }
}
-(void)getMyInfo{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSString *strURL =[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",appDelegate.session.accessToken];
    
    R9HTTPRequest *HTTPRequest = [[R9HTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [HTTPRequest setHTTPMethod:@"GET"];
    
    [HTTPRequest setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        
        if(responseString !=nil){
            id json=[responseString JSONValue];
            if(json==nil){
                return;
            }
            DebugLog(@"%@",[json description])
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            [self getFBFriend];
        }
        
    }];
    
    if ([HTTPRequest startRequest] == NO) {
        
    }
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
