//
//  NZIKey.h
//  PKISDKDemo
//
//  Created by LL on 16/3/22.
//  Copyright © 2016年 nationz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicConfig.h"


@interface NZIKey : NSObject

/***
 @description 选择Applet
 @param appletString:Applet十六进制字符转
 @reture 0:成功；其他：失败
 ***/
- (int)selectApplet:(NSString *)appletString;


/***
 @description 生成密钥对
 @param type:生成密钥对类型
 @reture 包含公钥和索引的字典对象
 ***/
- (NSDictionary *)generateCertificateKeyPairWithType:(CertificateTypes)type;

/***
 @description 导入证书
 @param certificateString:证书文件Base64编码
 @param index:密钥索引（长度为2的十六进制字符串，如@"00",@"0a"）
 @reture 0:成功；其他：失败
 ***/
- (int)importCertificate:(NSString *)certificateString atIndex:(NSString *)index;

/***
 @description 读取证书
 @param index:证书文件所在的索引
 @reture 证书文件Base64编码字符串
 ***/
- (NSString *)readCertificateAtIndex:(NSString *)index;

/***
 @description 删除证书
 @param index:证书文件所在的索引
 @param mode:删除证书的模式
 @reture 0:成功；其他：失败
 ***/
- (int)deleteCertificateAtIndex:(NSString *)index deleteMode:(DeleteFileModes)mode;

/***
 @description 验证用户PIN码
 @param PIN:用户PIN码（6位的数字字符串，如@"123456"，初始值为@"000000"）
 @reture 0:成功；其他：失败
 ***/
- (int)verifyUserPIN:(NSString *)PIN;

/***
 @description 修改用户PIN码
 @param oldPIN:旧PIN码
 @param newPIN:新PIN码
 @reture 0:成功；其他：失败
 ***/
- (int)changeUerPINByOldPIN:(NSString *)oldPIN andNewPIN:(NSString *)newPIN;

/***
 @description 重置用户PIN码
 @param NA
 @reture 0:成功；其他：失败
 ***/
- (int)initUserPIN;

/***
 @description 对称加密
 @param plaintext:加密明文（十六进制字符串）
 @param key:密钥（十六进制字符串）
 @reture 密文（十六进制字符串）
 ***/
- (NSString *)symmetricEncryptDataString:(NSString *)plaintext encryptKey:(NSString *)key;

/***
 @description 对称解密
 @param ciphertext:密文（十六进制字符串）
 @param key:密钥（十六进制字符串）
 @reture 明文（十六进制字符串）
 ***/
- (NSString *)symmetricDecryptDataString:(NSString *)ciphertext decryptKey:(NSString *)key;

/***
 @description 导入外部密钥
 @param keyPair:密钥（十六进制字符串）
 @param type:密钥类型
 @reture 密钥索引
 ***/
- (NSString *)importKeyPair:(NSString *)keyPair keyPairType:(KeyPairTypes)type;

/***
 @description 导入外部密钥
 @param keyPair:密钥（十六进制字符串）
 @param index:密钥索引
 @param type:密钥类型
 @reture 密钥索引
 ***/
- (NSString *)importKeyPair:(NSString *)keyPair atKeyIndex:(NSString *)index keyPairType:(KeyPairTypes)type;

/***
 @description 签名
 @param dataString:明文（普通字符串，如@"你好"）
 @param index:密钥索引
 @reture 签名数据（base64编码字符串）
 ***/
- (NSString *)signDataString:(NSString *)dataString byKeyAtIndex:(NSString *)index;

/***
 @description 验证签名
 @param signString:签名数据（base64编码字符串）
 @param message:明文（普通字符串，如@"你好"）
 @param index:密钥索引
 @reture 0:成功；其他：失败
 ***/
- (int)verifySignString:(NSString *)signString andMessage:(NSString *)message byKeyAtIndex:(NSString *)index;

/***
 @description 非对称加解密
 @param isDecrypy:YES表示解密；NO表示加密
 @param dataString:明/密文（十六进制字符串）
 @param index:密钥索引
 @reture 明文（十六进制字符串）
 ***/
- (NSString *)asymmetricDeEncrypy:(BOOL)isDecrypy dataString:(NSString *)dataString byKeyIndex:(NSString *)index;

/***
 @description 导出密钥
 @param index:密钥索引
 @reture 包含公钥和索引的字典对象
 ***/
- (NSDictionary *)exportPublicKeyByIndex:(NSString *)index;

/***
 @description SM1加解密
 @param dataString:明/密文（十六进制字符串）,长度为32的整数倍
 @param key:密钥（十六进制字符串）,长度为32
 @param isDecrypt 是否解密
 @param mode  加解密模式
 @reture 加解密后的数据
 ***/
- (NSString *)sm1DataString:(NSString *)dataString byKey:(NSString *)key isDecrypt:(BOOL)isDecrypt mode:(EncryptOrDecryptModes)mode;

@end



