//
//  CustomTableViewCell.m
//  mikan
//
//  Created by nasuryota on 2015/02/18.
//  Copyright (c) 2015年 mikan. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pushArchiveButton:(id)sender {
    _hasChecked = !_hasChecked;
    DLog(@"hasChecked = %d",_hasChecked);
    
    if(_hasChecked) {
        _archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
    } else {
        _archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
    }
}

+ (CGFloat)rowHeight
{
    return 55.0f;
}

@end
