//
//  DataUtils.h
//  Runner
//
//  Created by 玉成 on 2019/7/12.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataUtils : NSObject

- (NSData *)convertHexStrToData:(NSString *)str;

- (NSString *)convertDataToHexStr:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
