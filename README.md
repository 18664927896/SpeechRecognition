# SGSpeechRecognition
iOS原生语音识别技术

# 使用方法：
## 第一：初始化
-(SGSpeechRecognition *)speechRecognition{
    if (!_speechRecognition) {
        _speechRecognition = [SGSpeechRecognition new];
    }
    return _speechRecognition;
}


## 第二：开始识别
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

## 第三：语音识别结束
- (void)endRecording{
    [self.recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.speechRecognition endRecording];
}


