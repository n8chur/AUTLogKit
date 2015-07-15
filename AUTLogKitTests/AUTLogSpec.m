//
//  AUTLogSpec.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <AUTLogKit/AUTLogKit.h>
#import "DDStubLogger.h"

SpecBegin(AUTLog)

__block NSMutableArray *lastLogs;
__block DDStubLogger *stubLogger;

beforeEach(^{
    lastLogs = [NSMutableArray array];
    stubLogger = [[DDStubLogger alloc] initWithLogBlock:^(DDLogMessage *message) {
        [lastLogs addObject:message.message];
    }];
    [DDLog addLogger:stubLogger];
});

afterEach(^{
    [DDLog removeLogger:stubLogger];
});

it(@"it should initially log nothing", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelOff };

    NSString *log = @"This is a log";
    AUTLogError(AUTLogKitTestContext, @"%@", log);
    
    expect(lastLogs).will.haveACountOf(0);
});

it(@"it should initially log errors", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelError };

    NSString *log = @"This is a log";
    AUTLogError(AUTLogKitTestContext, @"%@", log);
    
    expect(lastLogs).will.haveACountOf(1);
    expect(lastLogs.firstObject).will.equal(log);
});

it(@"it should initially log everything", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelAll };
    
    NSString *logError = @"This is a log error";
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    NSString *logInfo = @"This is a log info";
    AUTLogInfo(AUTLogKitTestContext, @"%@", logInfo);
    
    expect(lastLogs).will.haveACountOf(2);
    expect(lastLogs.firstObject).will.equal(logError);
    expect(lastLogs.lastObject).will.equal(logInfo);
});

it(@"it should log after level change from off to error", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelOff };
    
    NSString *logError = @"This is a log error that will not be logged";
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    AUTLogContextSetLevel(&AUTLogKitTestContext, AUTLogLevelError);

    NSString *anotherLogError = @"This is a log error that will be logged";
    AUTLogError(AUTLogKitTestContext, @"%@", anotherLogError);
    
    expect(lastLogs).will.haveACountOf(1);
    expect(lastLogs.firstObject).will.equal(anotherLogError);
});

it(@"it should stop logging after level change from error to off", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelError };
    
    NSString *logError = @"This is a log error that will be logged";
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    AUTLogContextSetLevel(&AUTLogKitTestContext, AUTLogLevelOff);

    NSString *anotherLogError = @"This is a log error that will not be logged";
    AUTLogError(AUTLogKitTestContext, @"%@", anotherLogError);
    
    expect(lastLogs).will.haveACountOf(1);
    expect(lastLogs.firstObject).will.equal(logError);
});

SpecEnd
