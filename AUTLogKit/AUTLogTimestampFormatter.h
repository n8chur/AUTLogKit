//
//  AUTLogTimestampFormatter.h
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

/// Prepends a default timestamp to formatted logs.
@interface AUTLogTimestampFormatter : NSObject <DDLogFormatter>

@end

NS_ASSUME_NONNULL_END
