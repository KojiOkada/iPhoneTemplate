//
//  ViewController.h
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(void)sendRequest;
@property (strong, nonatomic) IBOutlet UIButton *buttonLoginLogout;
@property (strong, nonatomic) IBOutlet UITextView *textNoteOrLink;
@end
