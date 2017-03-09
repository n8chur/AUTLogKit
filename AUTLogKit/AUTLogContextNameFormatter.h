//
//  AUTLogContextNameFormatter.h
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import CocoaLumberjack;

NS_ASSUME_NONNULL_BEGIN

/// Prepends the name of the contexts to formatted logs.
@interface AUTLogContextNameFormatter : NSObject <DDLogFormatter>

@end

NS_ASSUME_NONNULL_END
