//
//  AUTLogRegexReplaceFormatter.h
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

/// A block that is invoked with the regex match and returns its replacement.
typedef NSString * _Nonnull (^AUTLogRegexMatchReplaceBlock)(NSString * match);

/// Invokes a block to provide a replacement string whenever a regular
/// expression matches any of the logs that it formats.
@interface AUTLogRegexReplaceFormatter : NSObject <DDLogFormatter>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithRegularExpression:(NSRegularExpression *)regularExpression matchReplaceBlock:(AUTLogRegexMatchReplaceBlock)matchReplaceBlock NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
