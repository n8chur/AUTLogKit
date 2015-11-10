//
//  AUTLog_Private.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

#define AUTLOGKIT_CONTEXT_CREATE(ctx, level) AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(ctx, level, #ctx)

#define AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(ctx, level, name) \
    AUTLogContext *ctx; \
    do { \
        ctx = AUTLogContextCreate(level, name); \
        AUTLogContextRegisterContext(ctx); \
    } while (0)

/// A method to reset list of previously registered contexts
void AUTLogContextResetRegisteredContexts();

NS_ASSUME_NONNULL_END
