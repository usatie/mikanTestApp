//
//  FirstViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LearnMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *sectionSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *totalRelearnButton;
@property (strong, nonatomic) IBOutlet UIButton *relearnButton;
@property (strong, nonatomic) IBOutlet UIButton *learnNewWordsButton;
@property (strong, nonatomic) IBOutlet UIButton *learnButton;


- (IBAction)learnCategoryChanged:(id)sender;

- (void)refreshButtonTitles;
@end