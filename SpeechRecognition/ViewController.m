//
//  ViewController.m
//  SpeechRecognition
//
//  Created by Saucheong Ye on 2019/6/14.
//  Copyright © 2019年 SHANGGANG. All rights reserved.
//

#import "ViewController.h"
#import "SGSpeechRecognition.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UILabel *showLabel;
@property (strong, nonatomic) SGSpeechRecognition *speechRecognition;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
    [self.recordButton setTitle:@"开始" forState:UIControlStateNormal];
     [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.recordButton addTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchDown];
     [self.recordButton addTarget:self action:@selector(endRecording) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:self.recordButton];
    
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 70)];
    self.showLabel.center= self.view.center;
    [self.view addSubview:self.showLabel];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SGSpeechRecognition authorization];
}


//开始识别
- (void)startRecording{
    [self.recordButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [self.speechRecognition startRecordingResultHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
        if (error) {
//            NSLog(@"识别失败");
            weakSelf.showLabel.text = @"识别失败";
        }else{
//           NSLog(@"识别成功");
            weakSelf.showLabel.text = str;
        }
        
    }];
}
//停止识别
- (void)endRecording{
    [self.recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.speechRecognition endRecording];
}

-(SGSpeechRecognition *)speechRecognition{
    if (!_speechRecognition) {
        _speechRecognition = [SGSpeechRecognition new];
    }
    return _speechRecognition;
}

@end
