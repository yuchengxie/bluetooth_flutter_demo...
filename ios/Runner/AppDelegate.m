#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "NZIKey.h"
#import "NZSIMSDK.h"
#import "DataUtils.h"

@interface AppDelegate()<NZSIMSDKDelegate>{
    NZSIMSDK *shareSdk;
    NZIKey *ikey;
    DataUtils * dataUtils;
}

@end

@implementation AppDelegate {
    FlutterEventSink _eventSink;
    FlutterViewController* controller;
    NSString * _blueToothState;
}

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    dataUtils=[[DataUtils alloc]init];
    _blueToothState=@"";
    controller =
    (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* bluetootheChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"hzf.bluetooth"
                                            binaryMessenger:controller];
    __weak typeof(self) weakSelf = self;
    
    [bluetootheChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                           FlutterResult result) {
         NSLog(@">>> method=%@ arguments = %@", call.method, call.arguments);
        if([@"connectBlueTooth" isEqualToString:call.method]){
            NSString *bleName=call.arguments[0];
            NSString *pinCode=call.arguments[1];
            [weakSelf connectBlueTooth:bleName :pinCode];
        }else if([@"disConnectBlueTooth" isEqualToString:call.method]){
            [weakSelf disConnectBlueTooth];
        }else if ([@"selectApp" isEqualToString:call.method]){
            NSString * resSelect =[weakSelf selectApp];
            result(resSelect);
        }else if ([@"verifPIN" isEqualToString:call.method]){
            NSString * resVerify= [weakSelf verifPIN];
            result(resVerify);
        }
    }];
    
    FlutterEventChannel *blueStateChnnel=[FlutterEventChannel eventChannelWithName:@"hzf.bluetoothState" binaryMessenger:controller];
    [blueStateChnnel setStreamHandler:self];
    //蓝牙部分
    shareSdk=[NZSIMSDK shareSdk];
    shareSdk.sim_delegate=self;
    ikey=[[NZIKey alloc]init];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
    NSLog(@"onListenWithArguments");
    _eventSink = eventSink;
    [self sendBlueToothConnectStateEvent];
    return nil;
}

- (void)sendBlueToothConnectStateEvent {
    if (!_eventSink) return;
    if(_blueToothState != @""){
        _eventSink(_blueToothState);
    }
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}

#pragma mark -bluetooth connect && disConnect
- (NSString*)connectBlueTooth: (NSString*)bleName :(NSString*) pinCode {
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    __block NSString* res;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int code=[shareSdk ConnectWithBleName:bleName andBleAuthCode:pinCode];
        res = code ==0?@"success":@"failed";
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    NSLog(@"结束connectBlueTooth调用");
    return res;
}

-(void)disConnectBlueTooth{
    NSLog(@"call disConnectBlueTooth");
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [shareSdk DisConnectBLE];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
}

#pragma mark -Application
-(NSString*)selectApp{
    //接口返回 -1代表失败//0代表成功
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    __block NSString* res=@"";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int code = [ikey selectApplet:@"D196300077130010000000020101"];
        res = code ==0?@"success":@"failed";
        NSLog(@"selectApp res:%@",res);
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    NSLog(@"结束selectApp调用");
    return res;
}

-(NSString*)verifPIN{
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    __block NSString* res=@"";
    NSString * s =@"0020000003000000";
    NSData * d=[dataUtils convertHexStrToData:s];
    NSLog(@"d: %@",d);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *r=[shareSdk SendSynchronized:d];
        res=[dataUtils convertDataToHexStr:r];
        NSLog(@"verify res:%@",res);
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    NSLog(@"结束verifypin调用");
    return res;
}

#pragma mark - NZBLESDK delegate
-(void)didConnectSuc{
    dispatch_async(dispatch_get_main_queue(), ^{
        _blueToothState=@"蓝牙连接成功";
        [self sendBlueToothConnectStateEvent];
    });
}

-(void)didDisConnect {
    NSLog(@"bluetooth disconnect!");
    dispatch_async(dispatch_get_main_queue(), ^{
        _blueToothState=@"蓝牙断开";
        [self sendBlueToothConnectStateEvent];
    });
}

@end
