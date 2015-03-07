//
//  TestViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
- (IBAction)backButtonPushed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *englishLabel;
- (IBAction)answerButtonPushed:(id)sender;
@property int modeId;
@property int sectionId;
@property NSDictionary *testWordsDic;

@end
