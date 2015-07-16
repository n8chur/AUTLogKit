//
//  AUTLog.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;
@import CocoaLumberjack;

typedef const void *AUTLogContextIdentifier;

typedef NS_OPTIONS(NSUInteger, AUTLogFlag) {
    AUTLogFlagError      = DDLogFlagError, // 0...00001
    AUTLogFlagInfo       = DDLogFlagInfo,  // 0...00100
};

typedef NS_OPTIONS(NSUInteger, AUTLogLevel) {
    AUTLogLevelOff   = 0,
    AUTLogLevelError = AUTLogFlagError,
    AUTLogLevelInfo  = (AUTLogLevelError | AUTLogFlagInfo),
    AUTLogLevelAll   = NSUIntegerMax,
};

/// A context to associate a group of related log statements.
///
/// For example, all logs related to network connections could be grouped into
/// a context.
typedef struct AUTLogContext {
     /// A log level for this context. Can be initialized with a default value.
     /// Use AUTSetContextLevel to set afterwards to ensure thread safety.
    volatile AUTLogLevel level;
} AUTLogContext;

/// A method to atomically set a log level for a given context.
bool AUTLogContextSetLevel(AUTLogContext* ctx, AUTLogLevel level);

/// A method to return a unique identifier for a given context
NSInteger AUTLogContextGetIdentifier(AUTLogContext *ctx);

/// Define version of the macro that only executes if the log level is above the threshold.
/// The compiled versions essentially look like this:
///
/// if (logFlagForThisLogMsg & logLevelForContext:XXX) { execute log message }
#define AUT_LOG_MAYBE(async, ctx, flg, tag, fnct, frmt, ...) \
        do { if(ctx.level & flg) LOG_MACRO(async, (DDLogLevel)ctx.level, (DDLogFlag)flg, AUTLogContextGetIdentifier(&ctx), tag, fnct, frmt, ##__VA_ARGS__); } while(0)

/// Ready to use context specific log macros.
#define AUTLogError(ctx, frmt, ...) AUT_LOG_MAYBE(NO,                ctx, AUTLogFlagError, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AUTLogInfo(ctx, frmt, ...)  AUT_LOG_MAYBE(LOG_ASYNC_ENABLED, ctx, AUTLogFlagInfo, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

/// General ready to use log macros
#define AUTLogGeneralError(frmt, ...) AUTLogError(AUTLogContextGeneric, ##__VA_ARGS__)
#define AUTLogGeneralInfo(frmt, ...)  AUTLogInfo(AUTLogContextGeneric, ##__VA_ARGS__)

extern AUTLogContext AUTLogContextGeneral;