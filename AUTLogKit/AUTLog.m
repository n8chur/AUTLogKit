//
//  AUTLog.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;
#import <libkern/OSAtomic.h>

#import "AUTLog.h"

AUTLogContext AUTLogContextGeneric = { .level = AUTLogLevelAll};

bool AUTLogContextSetLevel(AUTLogContext* ctx, AUTLogLevel level) {
    return OSAtomicCompareAndSwapLong(ctx->level, level, (volatile long *)&(ctx->level));
}

NSInteger AUTLogContextGetIdentifier(AUTLogContext *ctx) {
    return (NSInteger)ctx;
}
