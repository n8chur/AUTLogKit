//
//  AUTBlockLogger.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTBlockLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTBlockLogger ()

@property (nonatomic, copy) LogBlock logBlock;
@property (nonatomic, nullable) dispatch_queue_t queue;

@end

@implementation AUTBlockLogger

- (instancetype)init AUT_UNAVAILABLE_DESIGNATED_INITIALIZER;

- (instancetype)initWithLogBlock:(LogBlock)logBlock {
    return [self initWithLogBlock:logBlock queue:nil];
}

- (instancetype)initWithLogBlock:(LogBlock)logBlock queue:(nullable dispatch_queue_t)queue {
    NSParameterAssert(logBlock != nil);
    
    self = [super init];

    _logBlock = [logBlock copy];
    _queue = queue;
    
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    let formattedMessage = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;

    let queue = self.queue;
    if (queue != nil) {
        dispatch_async(queue, ^{
            self.logBlock(formattedMessage, logMessage);
        });
    } else {
        self.logBlock(formattedMessage, logMessage);
    }
}

@end

NS_ASSUME_NONNULL_END
