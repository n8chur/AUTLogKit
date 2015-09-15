//
//  AUTLogFormatter.m
//  Automatic
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "AUTLogKit.h"

#import "AUTLogFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTLogFormatter ()

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) AUTLogFormatterOutputOptions options;

@property (readonly, nonatomic, copy, nullable) NSDictionary *includedLevelsByContextIdentifiers;

@end

@implementation AUTLogFormatter


- (instancetype)init {
    return [self initWithDateFormatter:nil options:AUTLogFormatterOutputOptionsClient includingLevelsByContext:nil];
}

- (instancetype)initWithOptions:(AUTLogFormatterOutputOptions)options {
    return [self initWithDateFormatter:nil options:options];
}

- (instancetype)initWithOptions:(AUTLogFormatterOutputOptions)options includingLevelsByContext:(nullable NSDictionary *)includedLevelsByContext {
    return [self initWithDateFormatter:nil options:options includingLevelsByContext:includedLevelsByContext];
}

- (instancetype)initWithDateFormatter:(nullable NSDateFormatter *)formatter options:(AUTLogFormatterOutputOptions)options {
    return [self initWithDateFormatter:formatter options:options includingLevelsByContext:nil];
}

- (instancetype)initWithDateFormatter:(nullable NSDateFormatter *)formatter options:(AUTLogFormatterOutputOptions)options includingLevelsByContext:(nullable NSDictionary *)includedLevelsByContext {
    self = [super init];
    if (self == nil) return nil;
    
    _dateFormatter = formatter;
    _options = options;
    _includedLevelsByContext = [includedLevelsByContext copy];

    // When we get a log message, the context is an AUTLogContext Identifier,
    // so we can't easily go back to a context pointer.
    NSMutableDictionary *includedLevelsByContextIdentifiers = [NSMutableDictionary dictionary];
    [includedLevelsByContext enumerateKeysAndObjectsUsingBlock:^(NSValue *context, NSNumber *level, BOOL *stop) {
        includedLevelsByContextIdentifiers[@(AUTLogContextGetIdentifier(context.pointerValue))] = level;
    }];
    _includedLevelsByContextIdentifiers = [includedLevelsByContextIdentifiers copy];
    
    return self;
}

- (NSDateFormatter * __nonnull)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4; // 10.4+ style
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss:SSS";
    }
    
    return _dateFormatter;
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    // Filter out log messages with context we don't care about if configured
    if (![self shouldLogMessage:logMessage]) return nil;
    
    NSString *output = [logMessage.message copy];
 
    if (self.options == AUTLogFormatterOutputOptionsClient) {
        NSString *dateAndTime = [self.dateFormatter stringFromDate:logMessage.timestamp];
        output = [NSString stringWithFormat:@"%@ %@", dateAndTime, output];
    }
    
    // filter out empty logs
    return output.length > 0 ? output : nil;
}

- (BOOL)shouldLogMessage:(DDLogMessage *)logMessage {
    // If not levels are set, log everything.
    if (self.includedLevelsByContext == nil) return YES;

    // If the log message does not have a context, log.
    if (logMessage.context == 0) return YES;

    NSNumber *level = self.includedLevelsByContextIdentifiers[@(logMessage.context)];

    // If no level was specified for the given context, it should not be
    // logged.
    if (level == nil) return NO;

    // If the message's flag is found within the level mask, it should be logged.
    return (BOOL)(level.unsignedIntegerValue & logMessage.flag);
}

@end

NS_ASSUME_NONNULL_END
