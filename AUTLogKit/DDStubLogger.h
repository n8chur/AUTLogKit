//
//  DDStubLogger.h
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import UIKit;
@import CocoaLumberjack;

@interface DDStubLogger : DDAbstractLogger <DDLogger>

- (instancetype)init;
- (instancetype)initWithBlock:(void (^)(DDLogMessage*))logBlock NS_DESIGNATED_INITIALIZER;

@end
