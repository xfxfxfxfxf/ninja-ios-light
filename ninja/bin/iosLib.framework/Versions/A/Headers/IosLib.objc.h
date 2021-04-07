// Objective-C API for talking to github.com/ninjahome/ninja-go/cli_lib/ios Go package.
//   gobind -lang=objc github.com/ninjahome/ninja-go/cli_lib/ios
//
// File is generated by gobind. Do not edit.

#ifndef __IosLib_H__
#define __IosLib_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class IosLibIosApp;
@protocol IosLibAppCallBack;
@class IosLibAppCallBack;

@protocol IosLibAppCallBack <NSObject>
- (BOOL)immediateMessage:(NSString* _Nullable)from to:(NSString* _Nullable)to payload:(NSData* _Nullable)payload time:(int64_t)time error:(NSError* _Nullable* _Nullable)error;
- (BOOL)unreadMsg:(NSData* _Nullable)jsonData error:(NSError* _Nullable* _Nullable)error;
- (void)webSocketClosed;
@end

@interface IosLibIosApp : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@end

FOUNDATION_EXPORT NSString* _Nonnull IosLibActiveAddress(void);

FOUNDATION_EXPORT BOOL IosLibInitApp(NSString* _Nullable cipherTxt, NSString* _Nullable auth, id<IosLibAppCallBack> _Nullable callback, NSError* _Nullable* _Nullable error);

FOUNDATION_EXPORT NSString* _Nonnull IosLibNewWallet(NSString* _Nullable auth);

FOUNDATION_EXPORT BOOL IosLibWalletIsOpen(void);

FOUNDATION_EXPORT void IosLibWriteMessage(NSString* _Nullable To, NSData* _Nullable payload);

@class IosLibAppCallBack;

@interface IosLibAppCallBack : NSObject <goSeqRefInterface, IosLibAppCallBack> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (BOOL)immediateMessage:(NSString* _Nullable)from to:(NSString* _Nullable)to payload:(NSData* _Nullable)payload time:(int64_t)time error:(NSError* _Nullable* _Nullable)error;
- (BOOL)unreadMsg:(NSData* _Nullable)jsonData error:(NSError* _Nullable* _Nullable)error;
- (void)webSocketClosed;
@end

#endif