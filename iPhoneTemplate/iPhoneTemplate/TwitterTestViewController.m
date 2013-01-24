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
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error) {
                                if (granted) {
                                    _accounts = [[NSMutableArray alloc] initWithArray:[accountStore accountsWithAccountType:accountType]];
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                    });
                                    
                                    DebugLog(@"%@",[_accounts description])
                                } else {
                                    NSLog(@"許可されなかった");
                                }
                            }];
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
