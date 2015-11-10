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

NS_ASSUME_NONNULL_BEGIN

/// A dictionary representing the context identifiers mapped by the
/// corresponding context name.
/// In order to simplify thread synchronization, this object should only be
/// accessed from the main thread.
static NSMutableDictionary<NSString *, NSNumber *> *registeredContexts;

struct AUTLogContext {
    // A log level for this context that can be changed atomically using the
    // AUTLogContextSetLevel function.
    volatile AUTLogLevel level;
    // Human readable name for this context that can be changed using the
    // AUTLogContextSetName function.
    const char *name;
};

AUTLogContext * AUTLogContextCreate(AUTLogLevel level, const char *name) {
    AUTLogContext *ctx = malloc(sizeof(AUTLogContext));
    ctx->level = level;
    ctx->name = strdup(name);
    return ctx;
}

bool AUTLogContextSetLevel(AUTLogContext* ctx, AUTLogLevel level) {
    return OSAtomicCompareAndSwapLong(ctx->level, level, (volatile long *)&(ctx->level));
}

NSInteger AUTLogContextGetIdentifier(AUTLogContext *ctx) {
    return (NSInteger)ctx;
}

NSString * AUTLogContextGetName(AUTLogContext *ctx) {
    return [NSString stringWithUTF8String:ctx->name];
}

AUTLogLevel AUTLogContextGetLevel(AUTLogContext *ctx) {
    return ctx->level;
}

void AUTLogContextRegisterContext(AUTLogContext *context) {
    NSCAssert(NSThread.isMainThread, @"AUTLogContextRegisterContext must be invoked from the main thread");
    
    if (registeredContexts == nil) {
        registeredContexts = [NSMutableDictionary dictionary];
    }
    NSString *contextName = AUTLogContextGetName(context);
    
    // Assert if another context was already registered with same name
    NSCAssert(registeredContexts[contextName] == nil, @"Context '%@' already registered", contextName);
    
    registeredContexts[contextName] = @(AUTLogContextGetIdentifier(context));
}

AUTLogContext * __nullable AUTLogContextGetContext(NSInteger contextIdentifier) {
    NSCAssert(NSThread.isMainThread, @"AUTLogContextGetContext must be invoked from the main thread");
    
    // Verify the context identifier is a valid context and not an arbitrary
    // value set on a LogMessage
    if (![registeredContexts.allValues containsObject:@(contextIdentifier)]) return nil;
    
    return (AUTLogContext *)contextIdentifier;
}

NSArray * AUTLogContextRegisteredContexts() {
    NSCAssert(NSThread.isMainThread, @"AUTLogContextRegisteredContexts must be invoked from the main thread");
    
    if (registeredContexts == nil) {
        registeredContexts = [NSMutableDictionary dictionary];
    }
    return registeredContexts.allValues;
}

void AUTLogContextResetRegisteredContexts() {
    NSCAssert(NSThread.isMainThread, @"AUTLogContextResetRegisteredContexts must be invoked from the main thread");
    
    registeredContexts = [NSMutableDictionary dictionary];
}

NS_ASSUME_NONNULL_END
