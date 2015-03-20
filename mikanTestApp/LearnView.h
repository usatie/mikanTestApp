//
//  LearnView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LearnViewDelegate;

@interface LearnView : UIView
@property id <LearnViewDelegate> delegate;
@end

@protocol LearnViewDelegate <NSObject>

@optional

@end