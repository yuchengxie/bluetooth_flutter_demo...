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

const int BLUE_CONNCTED = 1;
const int BLUE_DISCONNECTED = 0;
const int BLUE_INIT = -1;
NSString * BLUENOTCONNCTED=@"蓝牙未连接,请先连接蓝牙";
NSString * BLUECONNECTEDSUCCESS=@"蓝牙连接成功";
NSString * BLUEDISCONNECTED=@"蓝牙断开";

@implementation AppDelegate {
    FlutterEventSink _eventSink;
    FlutterViewController* controller;
    int _blueToothState;
}

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    dataUtils=[[DataUtils alloc]init];
    _blueToothState = BLUE_INIT;
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
            NSString * appSelectID=call.arguments[0];
            NSString * resSelect =[weakSelf selectApp:appSelectID];
            result(resSelect);
        }else if ([@"verifPIN" isEqualToString:call.method]){
            NSString * strCode=call.arguments[0];
            NSString * resVerify= [weakSelf verifPIN:strCode];
            result(resVerify);
        }
    }];
    
    FlutterEventChannel *blueStateChnnel=[FlutterEventChannel eventChannelWithName:@"hzf.bluetoothState" binaryMessenger:controller];
    [blueStateChnnel setStreamHandler:self];
    shareSdk=[NZSIMSDK shareSdk];
    shareSdk.sim_delegate=self;
    ikey=[[NZIKey alloc]init];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    [self sendBlueToothConnectStateEvent];
    return nil;
}

- (void)sendBlueToothConnectStateEvent {
    if (!_eventSink || _blueToothState==BLUE_INIT) return;
    NSString * strState=_blueToothState == BLUE_CONNCTED? BLUECONNECTEDSUCCESS:BLUEDISCONNECTED;
    _eventSink(strState);
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
        res = code == 0? @"success": @"failed";
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    return res;
}

-(void)disConnectBlueTooth{
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [shareSdk DisConnectBLE];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
}

#pragma mark -Application
-(Boolean)isBlueToothConnected{
    if(_blueToothState==BLUE_CONNCTED) return true;
    return false;
}

//接口测试返回 其他代表失败//0代表成功
-(NSString*)selectApp:(NSString *) appSelectID{
    NSLog(@"appSelectID: %@",appSelectID);
    if(![self isBlueToothConnected]) return BLUENOTCONNCTED;
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    __block NSString* res=@"";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int code = [ikey selectApplet:appSelectID];
        res = code ==0?@"success":@"failed";
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    return res;
}

-(NSString*)verifPIN:(NSString *)codeStr{
    if(![self isBlueToothConnected]) return BLUENOTCONNCTED;
    dispatch_semaphore_t sema =dispatch_semaphore_create(0);
    __block NSString* res=@"";
    NSData * d=[dataUtils convertHexStrToData:codeStr];
    NSLog(@"d: %@",d);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *r=[shareSdk SendSynchronized:d];
        res=[dataUtils convertDataToHexStr:r];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
    return res;
}

#pragma mark - NZBLESDK delegate
-(void)didConnectSuc{
    dispatch_async(dispatch_get_main_queue(), ^{
        _blueToothState=BLUE_CONNCTED;
        [self sendBlueToothConnectStateEvent];
    });
}

-(void)didDisConnect {
    NSLog(@"bluetooth disconnect!");
    dispatch_async(dispatch_get_main_queue(), ^{
        _blueToothState=BLUE_DISCONNECTED;
        [self sendBlueToothConnectStateEvent];
    });
}

@end
