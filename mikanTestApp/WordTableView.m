//
//  WordTableView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "WordTableView.h"
#import "CustomTableViewCell.h"

@implementation WordTableView{
    NSDictionary *wordsDic;
    NSArray *resultImageNameArray;
}

//- (void)initWithFrame:(CGSize)frame{
//    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//
//}
- (id)initWithFrame:(CGRect)frame wordsDic:(NSDictionary *)wordsDictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UINib *nib = [UINib nibWithNibName:@"WordTableView" bundle:[NSBundle mainBundle]];
//        NSArray *array = [nib instantiateWithOwner:self options:nil];
//        self = [array objectAtIndex:0];
        self.frame = frame;
        wordsDic = wordsDictionary;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 55;
        resultImageNameArray = @[@"bad.png",@"good.png",@"great.png",@"excellent.png"];

        UINib *cellNib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
        [self registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    }
    return self;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        int answerIndex = [wordsDic[@"answerIndex"][indexPath.row] intValue];
        int testResultIndex = [wordsDic[@"testResult"][indexPath.row] intValue];
        BOOL hasRemembered = [wordsDic[@"hasRemembered"][indexPath.row] boolValue];

    static NSString *CellIdentifier = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor ];
    cell.englishLabel.text = wordsDic[@"english"][indexPath.row];
    cell.japaneseLabel.text = wordsDic[@"choicesArray"][indexPath.row][answerIndex-1];

    cell.evaluationImageView.image = [UIImage imageNamed:resultImageNameArray[testResultIndex]];
    cell.evaluationImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(hasRemembered) {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
        cell.hasChecked = YES;
    } else {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
        cell.hasChecked = NO;
    }
    cell.archiveImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(testResultIndex < 1) {
        //        [cell.archiveButton setImage:nil forState:UIControlStateDisabled];
        cell.archiveImageView.image = nil;
        cell.hasChecked = NO;
        cell.archiveButton.enabled = NO;
    }
    
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    cell.archiveButton.backgroundColor =alphaColor;
    
    return cell;
}
@end
