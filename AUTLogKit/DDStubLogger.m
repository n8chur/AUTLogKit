//
//  DDStubLogger.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/15/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "DDStubLogger.h"

@interface DDStubLogger ()

@property (nonatomic, copy) void (^logBlock)(DDLogMessage*);

@end

@implementation DDStubLogger

- (instancetype)init {
    return [self initWithBlock:nil];
}

- (instancetype)initWithBlock:(void (^)(DDLogMessage*))logBlock {
    NSParameterAssert(logBlock);
    
    self = [super init];
    if (self) {
        _logBlock = [logBlock copy];
    }
    
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    (_logBlock)(logMessage);
}

@end
