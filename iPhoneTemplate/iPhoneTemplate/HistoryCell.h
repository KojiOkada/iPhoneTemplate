//
//  HistoryCell.h
//  OrderingSystem
//
//  Created by システム管理者 on 13/01/22.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HistoryCellDelegate<NSObject>
-(void)tableViewCellAccessoryDidPush:(NSIndexPath*)indexPath;

@end
@interface HistoryCell : UITableViewCell
@property (nonatomic,retain) id<HistoryCellDelegate> delegate;
@property (nonatomic,retain) IBOutlet UILabel *tableName;
@property (nonatomic,retain) IBOutlet UILabel *customerSegment;
@property (nonatomic,retain) IBOutlet UILabel *customerCount;
@property (nonatomic,retain) IBOutlet UILabel *entryTime;
@property (nonatomic,retain) IBOutlet UILabel *exitTime;
@property (nonatomic,retain) NSIndexPath *selectedIndex;
-(IBAction)reEntryDidPush:(id)sender;
@end
