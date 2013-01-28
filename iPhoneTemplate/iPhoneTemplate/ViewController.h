//
//  ViewController.h
//  iPhoneTemplate
//
//  Created by システム管理者 on 13/01/24.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<FBLoginViewDelegate>
-(void)sendRequest;
@property (strong, nonatomic) IBOutlet GradientButton *buttonLoginLogout;
@property (strong, nonatomic) IBOutlet GradientButton *buttonTwitter;
@property (strong, nonatomic) IBOutlet GradientButton *buttonGetFriend;
@property (strong, nonatomic) IBOutlet UITextView *textNoteOrLink;
@end
