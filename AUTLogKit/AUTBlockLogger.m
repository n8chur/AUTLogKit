//
//  AUTBlockLogger.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "AUTBlockLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTBlockLogger ()

@property (nonatomic, copy) LogBlock logBlock;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation AUTBlockLogger

- (instancetype)init {
    NSString *reason = [NSString stringWithFormat:@"Use designated initializer instead"];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (instancetype)initWithLogBlock:(LogBlock)logBlock {
    return [self initWithLogBlock:logBlock queue:nil];
}

- (instancetype)initWithLogBlock:(LogBlock)logBlock queue:(nullable dispatch_queue_t)queue {
    NSParameterAssert(logBlock != nil);
    
    self = [super init];
    if (self == nil) return nil;

    _logBlock = [logBlock copy];
    _queue = queue;
    
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *formattedMessage = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;
    if (self.queue) {
        dispatch_async(self.queue, ^{
            self.logBlock(formattedMessage, logMessage);
        });
    } else {
        self.logBlock(formattedMessage, logMessage);
    }
}

@end

NS_ASSUME_NONNULL_END
