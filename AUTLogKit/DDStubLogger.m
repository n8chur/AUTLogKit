//
//  DDStubLogger.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "DDStubLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDStubLogger ()

@property (nonatomic, readonly, copy) void (^logBlock)(DDLogMessage *);

@end

@implementation DDStubLogger

- (instancetype)init {
    NSString *reason = [NSString stringWithFormat:@"Use designated initializer instead"];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (instancetype)initWithLogBlock:(void (^)(DDLogMessage*))logBlock {
    NSParameterAssert(logBlock != nil);
    
    self = [super init];
    if (self == nil) return nil;

    _logBlock = [logBlock copy];
    
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    self.logBlock(logMessage);
}

@end

NS_ASSUME_NONNULL_END
