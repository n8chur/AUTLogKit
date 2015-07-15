//
//  AUTLog.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;
@import CocoaLumberjack;

typedef void *AUTLogContext;

/**
 * The constant/variable/method responsible for controlling the current log level.
 **/
#ifndef LOG_LEVEL_DEF
    #define LOG_LEVEL_DEF ddLogLevel
#endif

#define AUTLogError(context, frmt, ...) LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError, (NSInteger)context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AUTLogInfo(context, frmt, ...)  LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,  (NSInteger)context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
