//
//  LearnViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractLearnViewController.h"

@interface LearnViewController : AbstractLearnViewController<AbstractLearnViewControllerDelegate>
@property UserUtil *util;
@end
