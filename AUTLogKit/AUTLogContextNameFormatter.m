//
//  AUTLogContextNameFormatter.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"
#import "AUTLog.h"

#import "AUTLogContextNameFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTLogContextNameFormatter

#pragma mark - AUTLogContextNameFormatter <DDLogFormatter>

- (nullable NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    if (logMessage.context == 0) return logMessage.message;

    let context = [AUTLogContext contextForIdentifier:logMessage.context];
    if (context == nil) return logMessage.message;

    return [context.name stringByAppendingFormat:@": %@", logMessage.message];
}

@end

NS_ASSUME_NONNULL_END
