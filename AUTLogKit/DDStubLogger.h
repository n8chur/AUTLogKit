//
//  DDStubLogger.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import UIKit;
@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

/// A logger that invokes block whenever it logs.
@interface DDStubLogger : DDAbstractLogger <DDLogger>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes a logger that invokes the logBlock when it logs a message with
/// the contents of the message.
- (instancetype)initWithLogBlock:(void (^)(DDLogMessage *))logBlock NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
