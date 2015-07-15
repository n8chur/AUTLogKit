//
//  AUTLog.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUTLog.h"
#import <libkern/OSAtomic.h>

bool AUTLogContextSetLevel(AUTLogContext ctx, AUTLogLevel level) {
    return OSAtomicCompareAndSwapLong(ctx.level, level, (volatile long *)&ctx.level);
}
