//
//  DxpSdkConfig.m
//  DxpBase
//
//  Created by 李标 on 2026/5/22.
//

#import "DxpSdkConfig.h"

@implementation DxpSdkConfig

- (id)init {
	self = [super init];
	if (self) {
		self.traceType = ONLY_CDP;
		self.traceFlushBulkSize = 100;
		self.isOpenLog = NO;
	}
	return self;
}

@end
