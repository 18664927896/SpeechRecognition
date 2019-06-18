//
//  SGSpeechRecognition1.m
//  SpeechRecognition
//
//  Created by Saucheong Ye on 2019/6/14.
//  Copyright © 2019年 SHANGGANG. All rights reserved.
//

#import "SGSpeechRecognition.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

@interface SGSpeechRecognition()<SFSpeechRecognizerDelegate>
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@end
@implementation SGSpeechRecognition


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initEngine];
    }
    return self;
}

//授权
+(void)authorization{
    //    __weak typeof(self) weakSelf = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    NSLog(@"语音识别未授权");
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    NSLog(@"用户未授权使用语音识别");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    NSLog(@"语音识别在这台设备上受到限制");
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    NSLog(@"语音识别");
                    break;
                    
                default:
                    break;
            }
            
        });
    }];
}

//初始化语音识别
- (void)initEngine {
    if (!self.speechRecognizer) {
        // 设置语言
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    }
    if (!self.audioEngine) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    if (!self.recognitionRequest) {
        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        self.recognitionRequest.shouldReportPartialResults = YES; // 实时翻译
    }
}

- (void)releaseEngine {
    [[self.audioEngine inputNode] removeTapOnBus:0];
    [self.audioEngine stop];
    [self.recognitionRequest endAudio];
//    self.recognitionRequest = nil;
}

//开始识别
- (void)startRecordingResultHandler:(void(^)(NSString * _Nullable str, NSError * _Nullable error))resultHandler{
    
    [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result.isFinal) {
            NSString *str = result.bestTranscription.formattedString;
            NSLog(@"%@",str);
            resultHandler(str,nil);
        }else if(!result){
            resultHandler(nil,error);
        }
    }];
    
    AVAudioFormat *recordingFormat = [[self.audioEngine inputNode] outputFormatForBus:0];
    [[self.audioEngine inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
}

- (void)startHandler:(void(^)(NSString * _Nullable str, NSError * _Nullable error))resultHandler{
    
}



//停止识别
- (void)endRecording{
    [self releaseEngine];
}

@end
