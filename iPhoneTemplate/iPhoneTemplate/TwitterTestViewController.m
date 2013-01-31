//
//  TwitterTestViewController.m
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//参考記事http://zero713.com/?p=583
//fb http://www.tryiphonedev.com/archives/67


#import "TwitterTestViewController.h"
#import "HistoryCell.h"
#import <Twitter/Twitter.h>
#import "BlocksKit.h"
@interface TwitterTestViewController ()

@end

@implementation TwitterTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accountStore = [[ACAccountStore alloc] init];
    accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error) {
                                if (granted) {
                                    _accounts = [[NSMutableArray alloc] initWithArray:[_accountStore accountsWithAccountType:accountType]];
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                    });
                                    if (account == nil) {
                                        NSArray *accountArray = [_accountStore accountsWithAccountType:accountType];
                                        account = [accountArray objectAtIndex:0];
                                        DebugLog(@"userName:%@",account.username)
                                        DebugLog(@"identifier:%@",account.identifier)
                                    }
                                    DebugLog(@"%@",[_accounts description])
                                    if([account.username length]> 0){
                                    //このアカウント情報からユーザーの名前をとったりができる
                                        [self sendRequest];
                                    }
                                } else {
//                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"えらー" message:@"nil"];
//                                    [alert addButtonWithTitle:@"OK" handler:nil];
//                                    [alert show];
                                    NSLog(@"許可されなかった");
                                }
                            }];
}

-(void)sendRequest{

    
if (account != nil) {
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/followers.json"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"20" forKey:@"count"];
//    [params setObject:@"1" forKey:@"include_entities"];
//    [params setObject:@"1" forKey:@"include_rts"];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                            
        if (responseData) {
            NSError *jsonError;
            NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData
            options:NSJSONReadingMutableLeaves error:&jsonError];
                                                DebugLog(@"%@", timeline);
        }
                                            
        }];
                                        
                                        
    }

}
#pragma mark TalbeViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_accounts count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *OrderedCellIdentifier = @"HistoryCell";
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:OrderedCellIdentifier];
    
    if (cell == nil) {
        cell = (HistoryCell *)[[[NSBundle mainBundle] loadNibNamed:OrderedCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectedIndex = indexPath;
    NSDictionary* dic = [_accounts objectAtIndex:indexPath.row];
    NSInteger count = [[dic objectForKey:@"customer_count"]intValue];
    cell.tableName.text = [NSString stringWithFormat:@"(%@)",[dic objectForKey:@"table_name"]];
    cell.customerSegment.text =[NSString stringWithFormat:@"%@",[dic objectForKey:@"customer_segment"]];
    cell.customerCount.text = [NSString stringWithFormat:@"%d人",count];
    cell.entryTime.text = [NSString stringWithFormat:@"入店時間:%@",[dic objectForKey:@"entry_time"]];
    cell.exitTime.text = [NSString stringWithFormat:@"退店時間:%@",[dic objectForKey:@"left_time"]];
    return cell;
    
    
}
#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

@end
