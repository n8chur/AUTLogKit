//
//  AUTLogFilteringFormatter.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTLogFilteringFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTLogFilteringFormatter

#pragma mark - Lifecycle

- (instancetype)init AUT_UNAVAILABLE_DESIGNATED_INITIALIZER;

- (instancetype)initWithIncludedLevelsByContextID:(NSDictionary<NSNumber *, NSNumber *> *)levelsByContextID {
    self = [super init];

    _includedLevelsByContextID = [levelsByContextID copy];

    return self;
}

#pragma mark - AUTLogFilteringFormatter <DDLogFormatter>

- (nullable NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    // If the log message does not have a context, log.
    if (logMessage.context == 0) return logMessage.message;

    let level = self.includedLevelsByContextID[@(logMessage.context)];

    // If no level was found, filter.
    if (level == nil) return nil;

    // If the message's flag is found within the level mask, it should be
    // logged, otherwise filtered.
    return (level.unsignedIntegerValue & logMessage.flag) ? logMessage.message : nil;
}

@end

NS_ASSUME_NONNULL_END
