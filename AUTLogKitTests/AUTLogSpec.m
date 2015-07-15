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
    stubLogger = [[DDStubLogger alloc] initWithBlock:^(DDLogMessage *message) {
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
    
    expect(lastLogs.count).will.equal(0);
});

it(@"it should initially log errors", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelError };

    NSString *log = @"This is a log";
    AUTLogError(AUTLogKitTestContext, @"%@", log);
    
    expect(lastLogs.count).will.equal(1);
    expect(lastLogs[0]).will.equal(log);
});

it(@"it should initially log everything", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelAll };
    
    NSString *logError = @"This is a log error";
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    NSString *logInfo = @"This is a log info";
    AUTLogInfo(AUTLogKitTestContext, @"%@", logInfo);
    
    expect(lastLogs.count).will.equal(2);
    expect(lastLogs[0]).will.equal(logError);
    expect(lastLogs[1]).will.equal(logInfo);
});

it(@"it should log after level change", ^{
    struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelOff };
    
    NSString *logError = @"This is a log error";
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    AUTLogContextSetLevel(&AUTLogKitTestContext, AUTLogLevelError);
    AUTLogError(AUTLogKitTestContext, @"%@", logError);
    
    expect(lastLogs.count).will.equal(1);
    expect(lastLogs[0]).will.equal(logError);
});

SpecEnd
