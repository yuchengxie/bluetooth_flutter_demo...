//
//  NZSIMSDK.h
//  NZSIMCore
//
//  Created by Liulu on 16/7/27.
//  Copyright © 2016年 nationz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NZSIMSDKDelegate <NSObject>

@optional
- (void)didConnectSuc;//连接成功的回调，必须设置sim_delegate的值
- (void)didDisConnect;//断开连接
- (void)overtimeConnect;//连接超时
- (void)didConnectFail;//连接失败

@end

@interface NZSIMSDK : NSObject

@property (nonatomic, weak)id<NZSIMSDKDelegate> sim_delegate;

@property (nonatomic, assign, readonly) BOOL connectStatus; //当前蓝牙状态

@property (nonatomic, assign) NSTimeInterval overtimeTimeInterval;//连接超时时间设置，默认20s；

+ (NZSIMSDK *)shareSdk;

- (int)ConnectWithBleName:(NSString *)ble_name andBleAuthCode:(NSString *)ble_authCode;

- (NSData *)SendSynchronized:(NSData *)inputData;//同步发送数据

- (void)DisConnectBLE;//断开蓝牙连接

- (NSString *)GetVersion;//获取SDK版本号

@end
