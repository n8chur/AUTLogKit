//
//  AUTLogFilteringFormatter.h
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

/// A custom log formatter that filters logs at specified levels originating in
/// certain contexts.
@interface AUTLogFilteringFormatter : NSObject <DDLogFormatter>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIncludedLevelsByContextID:(NSDictionary<NSNumber *, NSNumber *> *)levelsByContextID NS_DESIGNATED_INITIALIZER;

/// A dictionary of <AUTLogContextIdentifier: AUTLogLevel> specifying the
/// highest level for each context that should be logged by this formatter..
///
/// Contexts that are not included in this dictionary will be filtered.
///
/// Log messages with no context will not be filtered.
@property (readonly, nonatomic, copy) NSDictionary<NSNumber *, NSNumber *> *includedLevelsByContextID;

@end

NS_ASSUME_NONNULL_END
