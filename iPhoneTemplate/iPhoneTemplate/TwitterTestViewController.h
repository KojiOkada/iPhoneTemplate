//
//  TwitterTestViewController.h
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
@interface TwitterTestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *accounts;
@end
