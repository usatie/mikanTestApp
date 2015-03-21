//
//  SampleLearnViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractLearnViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SampleLearnViewController : AbstractLearnViewController<AbstractLearnViewControllerDelegate>
@property AVAudioPlayer *audio;
@end
