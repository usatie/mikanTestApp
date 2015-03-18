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
    DLog(@"hasChecked = %d",_hasChecked);
    _hasChecked = !_hasChecked;
    if(_hasChecked) {
        _archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
        [self checked];
    } else {
        _archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
        [self unchecked];
    }
}

- (void)checked
{
    [_checkWords addObject:@"a"];
    [_checkWords addObject:@"b"];
    DLog(@"checkWords = %@",_checkWords);
}

- (void)unchecked
{
    [_checkWords removeObject:@"b"];
    DLog(@"checkWords = %@",_checkWords);
}

+ (CGFloat)rowHeight
{
    return 55.0f;
}

@end
