//
//  HistoryCell.m
//  OrderingSystem
//
//  Created by システム管理者 on 13/01/22.
//  Copyright (c) 2013年 koji.Okada. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell ()

@end

@implementation HistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)reEntryDidPush:(id)sender{
    if(_selectedIndex==nil){
        return;
    }
    if([_delegate respondsToSelector:@selector(tableViewCellAccessoryDidPush:)]){
        [_delegate tableViewCellAccessoryDidPush:_selectedIndex];
    }
}


@end
