//
//  WordTableView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
- (id)initWithFrame:(CGRect)frame wordsDic:(NSDictionary *)wordsDictionary;
@end
