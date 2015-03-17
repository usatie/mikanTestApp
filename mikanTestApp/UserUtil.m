//
//  Util.m
//  mikan
//
//  Created by tomoaki saito on 2014/09/17.
//  Copyright (c) 2014年 mikan. All rights reserved.
//

#import "UserUtil.h"
#import <NCMB/NCMB.h>
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>


@implementation UserUtil

#pragma mark Post Data
-(void)postFileNameToNCMB:(NSString*)fileName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:UD_WORD_BUG_REPORT]];
    NSUInteger wordIndex = [array indexOfObject:fileName];

    if (wordIndex == NSNotFound && fileName) {
        DLog(@"%@ is new bug!", fileName);
        NCMBObject *post = [NCMBObject objectWithClassName:UD_WORD_BUG_REPORT];
        NSString *category = [userDefaults objectForKey:UD_KEY_CATEGORY];
        NSNumber *rank = [NSNumber numberWithInteger:[userDefaults integerForKey:UD_KEY_RANK]];
        [post setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"user"];
        [post setObject:fileName forKey:@"word"];
        [post setObject:category forKey:UD_KEY_CATEGORY];
        [post setObject:rank forKey:UD_KEY_RANK];
        [post setObject:[NSNumber numberWithInteger:[userDefaults integerForKey:UD_KEY_SECTION]] forKey:UD_KEY_SECTION];
        [post setObject:@"no sound" forKey:@"bugType"];
        
        NSMutableArray *soundReloadArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:UD_RELOAD_SOUND_ARRAY]];
        NSDictionary *insertDic = @{@"category":category, @"rank":rank};
        NSUInteger rankIndex = [soundReloadArray indexOfObject:insertDic];
        if (rankIndex == NSNotFound) {
            [soundReloadArray addObject:insertDic];
            [userDefaults setObject:soundReloadArray forKey:UD_RELOAD_SOUND_ARRAY];
        }
        
        [array addObject:fileName];
        [userDefaults setObject:array forKey:UD_WORD_BUG_REPORT];
        [userDefaults synchronize];
        [post saveInBackgroundWithBlock:nil];
    }
}
- (void)postGetWordsDataBugReport:(NSString *)method category:(NSString *)category
{
    DLog(@"postWordsReadBugReport");
    NCMBObject *post = [NCMBObject objectWithClassName:@"wordsReadBugReport"];
    [post setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"user"];
    [post setObject:category forKey:@"category"];
    [post setObject:method forKey:@"method"];
    
    [post saveInBackgroundWithBlock:nil];
}

- (NSArray *)makeParameterArray:(NSArray *)nameArray valueArray:(NSArray *)valueArray
{
    DLog(@"makeParameterArray");
    if (nameArray.count != valueArray.count) {
        DLog(@"makeParameterArray Error: The number of elements doesn't match.");
        return nil;
    }
    NSMutableArray *parameterArray = [[NSMutableArray alloc] init];
    for (int i = 0;i < nameArray.count; i++) {
        [parameterArray addObject:@{@"name":nameArray[i],@"value":valueArray[i]}];
    }
    return parameterArray;
}

- (void)jsonLogData:(NSString *)action parameterArray:(NSArray *)parameter
{
    DLog(@"jsonLogData:%@",action);
    NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    //送信するパラメータの組み立て
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setValue:action forKey:@"action_name"];
    [mutableDic setValue:udid forKey:@"user_name"];
    [mutableDic setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"timestamp"];
    
    if (parameter != nil) {
        DLog(@"with parameter %@",parameter);
        [mutableDic setValue:parameter forKey:@"parameter"];
    } else {
        DLog(@"without parameter");
    }
    NSDictionary *dataDic = @{@"tmp_action":mutableDic};
    DLog(@"dataDic = %@",dataDic);
    NSError *error;
    NSMutableData *data;
    if ([NSJSONSerialization isValidJSONObject:dataDic]) {
        DLog(@"isValidjson!");
        #ifdef DEBUG
        data = [[NSMutableData alloc] initWithData:[@"D" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:&error]];
        #else
        data = [[NSMutableData alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:&error]];
        #endif
        [self kinesisStream:data];
        DLog(@"json error = %@",error);
    } else {
        DLog(@"isInvalidjson!");
        return;
    }

    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *fileName = [NSString stringWithFormat:@"%@_flydata_error.json",[UIDevice currentDevice].identifierForVendor.UUIDString];
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    DLog(@"filePath = %@",filePath);
    if (![fileManager fileExistsAtPath:filePath]) { // yes
        // 空のファイルを作成する
        BOOL result = [fileManager createFileAtPath:filePath
                                           contents:[NSData data] attributes:nil];
        if (!result) {
            DLog(@"ファイルの作成に失敗");
            return;
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!fileHandle) {
        DLog(@"ファイルハンドルの作成に失敗");
        return;
    }
    
    NSData *newLine = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:newLine];
    if (error) DLog(@"error = %@",error);
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle synchronizeFile];
    [fileHandle closeFile];
    
    DLog(@"ファイルの書き込みが完了しました．");
}


- (void)kinesisStream:(NSData *)data
{
    AWSKinesisRecorder *kinesisRecorder = [AWSKinesisRecorder defaultKinesisRecorder];
    [[[kinesisRecorder saveRecord:data
                       streamName:@"mikan-analytics-us-east-1"] continueWithSuccessBlock:^id(BFTask *task) {
        return [kinesisRecorder submitAllRecords];
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            DLog(@"Error: %@", task.error);
        }
        return nil;
    }];
}

- (void)showLTSV
{
    // ホームディレクトリを取得
    NSString *tmpDir = NSTemporaryDirectory();
    // 書き込みたいファイルのパスを作成
    NSString *fileName = [NSString stringWithFormat:@"%@.ltsv",[UIDevice currentDevice].identifierForVendor.UUIDString];
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    // ファイルハンドルを作成する
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) {
        DLog(@"ファイルがありません．");
        return;
    }
    
    // ファイルから末尾までのデータを取得
    NSData *data = [fileHandle readDataToEndOfFile];
    // データを文字列に変換
    NSString *str = [[NSString alloc]initWithData:data
                                         encoding:NSUTF8StringEncoding];
    DLog(@"%@", str);
    // ファイルを閉じる
    [fileHandle closeFile];
}

#pragma mark Audio

-(void)playSound:(NSString *)fileName playSoundFlag:(BOOL)playSoundFlag
{
    DLog(@"pronounce \"%@\"", fileName);
    if (!playSoundFlag)return;
    
    NSString *extension = @"mp3";
    NSArray *docDirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [docDirArray objectAtIndex:0];
    NSString *dirName = @"voice";
    NSString *filePath = [docDirPath stringByAppendingPathComponent:dirName];
    NSString *file = [NSString stringWithFormat:@"%@.%@",fileName, extension];
    filePath = [filePath stringByAppendingPathComponent:file];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSError *error;
    
    _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    
    DLog(@"%@", fileUrl);
    
    if (error) {
        DLog(@"could not pronounce %@", fileName);
        [self postFileNameToNCMB:fileName];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([fileName  isEqualToString: @"sound_finish"] ||[fileName isEqualToString:@"sound_correct"] || [fileName isEqualToString:@"sound_incorrect"]){
        self.soundPlayer.volume = [ud floatForKey:@"soundEffectVolume"];
    } else {
        self.soundPlayer.volume = [ud floatForKey:@"pronounceSoundVolume"];
    }
    [self.soundPlayer play];
}

#pragma mark Configuration
- (NSUInteger)returnVersion:(NSString *)appVersion{
    NSUInteger versionNum = 0;
    NSArray *versionNumArray = [appVersion componentsSeparatedByString:@"."];
    for (int i=0; i<versionNumArray.count; i++){
        NSString *version = [versionNumArray objectAtIndex:i];
        versionNum += [version longLongValue] * ((NSUInteger)pow(100,(3-i)));
    }
    return versionNum;
}

#pragma mark Small Settings
-(void) setExclusiveTouchForView:(UIView*)view
{
    for (UIView *subview in view.subviews) {
        subview.exclusiveTouch = YES;
        [self setExclusiveTouchForView:subview];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    DLog(@"addSkipBackupAttributeToItemAtURL");
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        DLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end