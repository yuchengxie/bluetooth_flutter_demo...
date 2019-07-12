//
//  PublicConfig.h
//  PKISDKDemo
//
//  Created by LL on 16/3/30.
//  Copyright © 2016年 nationz. All rights reserved.
//

#ifndef PublicConfig_h
#define PublicConfig_h

typedef NS_ENUM(NSUInteger, CertificateTypes) {
    CertificateTypeRSA1024,
    CertificateTypeRSA2048,
    CertificateTypeSM2_256,
};

typedef NS_ENUM(NSUInteger, DeleteFileModes) {
    DeleteFileModeDeleteFile,
    DeleteFileModeDeleteFileAndPrivateKey
};

typedef NS_ENUM(NSUInteger, KeyPairTypes) {
    KeyPairTypeRSAPrivateKey,
    KeyPairTypeRSAPublicKey,
    KeyPairTypeSM2PrivateKey,
    KeyPairTypeSM2PublicKey
};

typedef NS_ENUM(NSUInteger, EncryptOrDecryptModes) {
    EncryptOrDecryptModeECB,
    EncryptOrDecryptModeCBC,
};

#endif /* PublicConfig_h */
