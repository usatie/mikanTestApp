//
//  CustomTableViewCell.h
//  mikan
//
//  Created by nasuryota on 2015/02/18.
//  Copyright (c) 2015年 mikan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *japaneseLabel;
@property (strong, nonatomic) IBOutlet UIImageView *evaluationImageView;
@property (strong, nonatomic) IBOutlet UIImageView *archiveImageView;
@property (strong, nonatomic) IBOutlet UIButton *archiveButton;
@property (nonatomic) BOOL hasChecked;
- (IBAction)pushArchiveButton:(id)sender;


+ (CGFloat)rowHeight;

@property NSMutableArray* checkWords;

@end
