//
//  AUTLog.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;
@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

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
typedef struct AUTLogContext AUTLogContext;

/// Create a new context
AUTLogContext *AUTLogContextCreate(AUTLogLevel level, const char *name);

/// A method to atomically set a log level for a given context.
bool AUTLogContextSetLevel(AUTLogContext *ctx, AUTLogLevel level);

/// A method to return a unique identifier for a given context
NSInteger AUTLogContextGetIdentifier(AUTLogContext *ctx);

/// A method to return log level for a given context
AUTLogLevel AUTLogContextGetLevel(AUTLogContext *ctx);

/// A method to return the name for a given context
NSString * AUTLogContextGetName(AUTLogContext *ctx);

/// Return a context given a valid context identifier or nil otherwise.
AUTLogContext * __nullable AUTLogContextGetContext(NSInteger contextIdentifier);

/// A method that returns all registered contexts identifiers.
NSArray<NSNumber *> * AUTLogContextRegisteredContexts();

/// A method to register a context
void AUTLogContextRegisterContext(AUTLogContext *context);

/// Define version of the macro that only executes if the log level is above the threshold.
/// The compiled versions essentially look like this:
///
/// if (logFlagForThisLogMsg & logLevelForContext:XXX) { execute log message }
#define AUT_LOG_MAYBE(async, ctx, flg, tag, fnct, frmt, ...) \
        do { if(AUTLogContextGetLevel(ctx) & flg) LOG_MACRO(async, (DDLogLevel)AUTLogContextGetLevel(ctx), (DDLogFlag)flg, AUTLogContextGetIdentifier(ctx), tag, fnct, frmt, ##__VA_ARGS__); } while(0)

/// Ready to use context specific log macros.
///
/// Macros are asynchronous for all flags. This prevents a deadlock inside
/// CocoaLumberjack when a combination of synchronous vs asynchronous calls
/// are used. This is at the expense of potentially missing some critical logs
/// in the case of a crash.
#define AUTLogError(ctx, frmt, ...) AUT_LOG_MAYBE(YES, ctx, AUTLogFlagError, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AUTLogInfo(ctx, frmt, ...)  AUT_LOG_MAYBE(YES, ctx, AUTLogFlagInfo, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

/// A macro to define a given context in a header file as extern.
#define AUTLOGKIT_CONTEXT_DECLARE(ctx) extern AUTLogContext *ctx;

/// A macro to initialize a given context in an implementation file passing
/// a level. The context name will default to the context variable name.
#define AUTLOGKIT_CONTEXT_INIT(ctx, level) AUTLOGKIT_CONTEXT_INIT_WITH_NAME(ctx, level, #ctx)

/// A macro to initialize a given context in an implementation file passing
/// a default level and a context name, automatically registering it at load
/// time using static method.
#define AUTLOGKIT_CONTEXT_INIT_WITH_NAME(ctx, level, name) \
    AUTLogContext *ctx; \
    __attribute__((constructor)) static void Register_##ctx(void) { \
        ctx = AUTLogContextCreate(level, name); \
        AUTLogContextRegisterContext(ctx); \
    }

NS_ASSUME_NONNULL_END
