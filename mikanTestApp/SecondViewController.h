//
//  SecondViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *resultsTableView;
- (IBAction)deleteButtonPushed:(id)sender;


@end

