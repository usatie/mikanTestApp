//
//  FirstViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPushed:(id)sender {
    NSLog(@"mode selectedSegmentedIndex = %d", (int)_modeSegmentedControl.selectedSegmentIndex);
    NSLog(@"section selectedSegmentedIndex = %d", (int)_sectionSegmentedControl.selectedSegmentIndex);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:_modeSegmentedControl.selectedSegmentIndex forKey:@"testMode"];
    [ud setInteger:_sectionSegmentedControl.selectedSegmentIndex forKey:@"testSection"];
    [ud synchronize];
    [self performSegueWithIdentifier:@"segueToTest" sender:self];
}
@end
