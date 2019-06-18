//
//  SGSpeechRecognition1.h
//  SpeechRecognition
//
//  Created by Saucheong Ye on 2019/6/14.
//  Copyright © 2019年 SHANGGANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^backSpeechStingBlock)(NSString *str);

@interface SGSpeechRecognition : NSObject

//授权
+(void)authorization;
//开始识别
//- (void)startRecording;
- (void)startRecordingResultHandler:(void(^)(NSString * _Nullable str, NSError * _Nullable error))resultHandler;
//停止识别
- (void)endRecording;

@end

NS_ASSUME_NONNULL_END
