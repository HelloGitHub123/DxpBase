//
//  DxpSdkConfig.h
//  DxpBase
//
//  Created by 李标 on 2026/5/22.
//  DXP SDK 配置类 (全家桶)

#import <Foundation/Foundation.h>

#import <DXPAnalyticsLib/DxpTrace.h>
NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, DxpTraceType) {
//	ONLY_CDP = 1,  // ONLY_CDP
//	ONLY_GA = 2,   // ONLY_GA
//	BOTH = 3       // BOTH
//};

@interface DxpSdkConfig : NSObject

// 必须
@property (nonatomic, copy) NSString *dxpUrl;
@property (nonatomic, copy) NSString *clientKey;
// 埋点
@property (nonatomic, assign) DxpTraceType traceType; // 默认为 1 (ONLY_CDP)
@property (nonatomic, copy) NSString *traceUrl; // CDP 上报地址
@property (nonatomic, assign) int traceFlushBulkSize; // 神策批量上报阈值
@property (nonatomic, strong) NSDictionary *tracePublicProperties; // 埋点公共属性（所有事件自动携带）
@property (nonatomic, assign) BOOL isOpenLog; // 是否打开日志
// DxpPush
@property (nonatomic, copy) NSString *groupId;
// promotion popup


@end

NS_ASSUME_NONNULL_END
