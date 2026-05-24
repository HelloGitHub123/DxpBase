//
//  DxpSdk.m
//  DxpBase
//
//  Created by 李标 on 2026/5/22.
//

#import "DxpSdk.h"
#import <DXPToolsLib/DXPHJToolsHeader.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <DXPAnalyticsLib/DxpTrace.h>
#import <DxpPromotionDialog/DXPPromotionDialog.h>
#import <DxpUserManagement/DxpUserManagement.h>
#import <DxpPromotionDialog/DXPPromoUserData.h>
#import <DxpUserManagement/DxpUserData.h>
#import <DXPToolsLib/HJTool.h>
#import <DxpPush/DxpPush.h>

static DxpSdkPushOpenURLHandler _pushOpenURLHandler;

@implementation DxpSdk

+ (void)setPushOpenURLHandler:(DxpSdkPushOpenURLHandler)handler {
	_pushOpenURLHandler = [handler copy];
}

+ (void)setupPushOpenURLForwarding {
	[DxpPush getInstance].dxpPushOpenURLBlock = ^(NSString *openURL) {
		if (openURL.length == 0) {
			return;
		}
		DxpSdkPushOpenURLHandler handler = _pushOpenURLHandler;
		if (handler) {
			handler(openURL);
		}
	};
}

// 初始化SDK
+ (void)initializeSdk:(DxpSdkConfig *)sdkConfig {
	if (!sdkConfig) {
		NSLog(@"DxpSdkConfig cannot be null");
		return;
	}
	// 验证必填参数并提取
	NSString *dxpUrl = sdkConfig.dxpUrl;
	if (isEmptyString_tools(dxpUrl)) {
		NSLog(@"dxpUrl cannot be null or empty in DxpSdkConfig");
		return;
	}
	NSString *clientKey = sdkConfig.clientKey;
	if (isEmptyString_tools(clientKey)) {
		NSLog(@"clientKey cannot be null or empty in DxpSdkConfig");
		return;
	}
	[DCNetAPIClient sharedClient].baseUrl = dxpUrl;
	[DCNetAPIClient sharedClient].clientKey = clientKey;
	
	// 初始化埋点
	[DxpTrace getInstance].traceType = sdkConfig.traceType;
	[DxpTrace getInstance].traceUrl = sdkConfig.traceUrl;
	[DxpTrace getInstance].traceFlushBulkSize = sdkConfig.traceFlushBulkSize;
	[DxpTrace getInstance].isOpenLog = sdkConfig.isOpenLog;
	[[DxpTrace getInstance] sharedInstanceWithLaunchOptions];
	// 自定义埋点
	[DxpTrace getInstance].tracePublicProperties = sdkConfig.tracePublicProperties;
	
	// Push
	[DxpPush getInstance].groupId = sdkConfig.groupId;
	[self setupPushOpenURLForwarding];

	// TODO: 初始化日志管理
	
}

+ (void)login:(NSString *)custNbr
serviceNumber:(NSString *)serviceNumber
       subsId:(NSString *)subsId
   completion:(DxpUserManagementLoginCompletion)completion {
	[DxpUserManagement login:custNbr serviceNumber:serviceNumber subsId:subsId completion:^(DxpUserData * _Nullable model, NSString * _Nonnull message) {
		if (model) {
			[DXPPromoUserData sharedInstance].subsId = @([model.subsId intValue]);
			[DXPPromoUserData sharedInstance].serviceNumber = model.serviceNumber;
			[DXPPromoUserData sharedInstance].token = model.token;
		}
		if (completion) {
			completion(model, message);
		}
	}];
}

// 登出
+ (void)logout:(NSString *)pushToken
pushServiceVendor:(NSString *)pushServiceVendor
     completion:(DxpUserManagementLogoutCompletion)completion {
	[DxpUserManagement logout:pushToken pushServiceVendor:pushServiceVendor completion:^(DxpUserIdentityLogoutModel * _Nullable model, NSString * _Nonnull message) {
		if (completion) {
			completion(model, message);
		}
	}];
}

// 上报接口
+ (void)deviceTokenReport:(NSString *)pushToken
      pushServiceVendor:(NSString *)pushServiceVendor
             completion:(DxpUserManagementDeviceReportCompletion)completion {
	[DxpUserManagement deviceTokenReport:pushToken pushServiceVendor:pushServiceVendor completion:^(DxpDeviceReportModel * _Nullable model, NSString * _Nonnull message) {
		if (completion) {
			completion(model, message);
		}
	}];
}

// 弹出popup 弹框
+ (void)showPromotion {
	[DXPPromotion refreshDataOnViewController:[HJTool currentVC] completion:^(BOOL success) {
		dispatch_async(dispatch_get_main_queue(), ^{
			// TDDO:界面提示之类的
		});
	}];
}

@end
