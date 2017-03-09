//
//  AUTLogTimestampFormatter.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTLogTimestampFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTLogTimestampFormatter ()

@property (readonly, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation AUTLogTimestampFormatter

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    _dateFormatter = [[NSDateFormatter alloc] init];

    // 10.4+ style
    _dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
    _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss:SSS ";

    return self;
}

#pragma mark - AUTLogTimestampFormatter <DDLogFormatter>

- (nullable NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    let timestamp = [self.dateFormatter stringFromDate:logMessage.timestamp];

    return [timestamp stringByAppendingString:logMessage.message];
}

@end

NS_ASSUME_NONNULL_END
