//
//  NSArray+IndexHelper.m
//  mikan
//
//  Created by Shun Usami on 2015/03/13.
//  Copyright (c) 2015年 mikan. All rights reserved.
//

#import "NSArray+IndexHelper.h"

@implementation NSArray (IndexHelper)
- (id) safeObjectAtIndex:(NSUInteger)index
{
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
