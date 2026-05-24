//
//  DxpSdk.h
//  DxpBase
//
//  Created by 李标 on 2026/5/22.
//

#import <Foundation/Foundation.h>
#import "DxpSdkConfig.h"
#import <DxpUserManagement/DxpUserManagement.h>

NS_ASSUME_NONNULL_BEGIN

/// 推送点击跳转 URL 回调（DeepLink / WebView / Action 等），参数为 jumpUrl / openURL
typedef void (^DxpSdkPushOpenURLHandler)(NSString *openURL);

@interface DxpSdk : NSObject

// 初始化SDK
+ (void)initializeSdk:(DxpSdkConfig *)sdkConfig;

/// 注册推送 openURL 回调，建议在 `initializeSdk:` 之前调用；也可在初始化之后补设
+ (void)setPushOpenURLHandler:(nullable DxpSdkPushOpenURLHandler)handler;

// 登录接口
+ (void)login:(NSString *)custNbr
serviceNumber:(NSString *)serviceNumber
       subsId:(NSString *)subsId
   completion:(nullable DxpUserManagementLoginCompletion)completion;

// 展示弹框
+ (void)showPromotion;

// 登出
+ (void)logout:(NSString *)pushToken
pushServiceVendor:(NSString *)pushServiceVendor
     completion:(nullable DxpUserManagementLogoutCompletion)completion;

// 上报接口
+ (void)deviceTokenReport:(NSString *)pushToken
      pushServiceVendor:(NSString *)pushServiceVendor
             completion:(nullable DxpUserManagementDeviceReportCompletion)completion;

@end

NS_ASSUME_NONNULL_END
