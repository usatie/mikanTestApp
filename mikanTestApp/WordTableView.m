//
//  WordTableView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "WordTableView.h"

@implementation WordTableView

//- (void)initWithFrame:(CGSize)frame{
//    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//
//}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"WordTableView" bundle:[NSBundle mainBundle]];
        NSArray *array = [nib instantiateWithOwner:self options:nil];
        self = [array objectAtIndex:0];
        self.frame = frame;
        UINib *cellNib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
        [self registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    }
    return self;

}
@end
