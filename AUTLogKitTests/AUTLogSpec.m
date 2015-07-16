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
#import "AUTBlockLogger.h"

SpecBegin(AUTLog)

__block NSMutableArray *lastLogs;
__block AUTBlockLogger *blockBlogger;

describe(@"change log filters using contexts and log levels", ^{
    beforeEach(^{
        lastLogs = [NSMutableArray array];
        blockBlogger = [[AUTBlockLogger alloc] initWithLogBlock:^(NSString *formattedMessage, DDLogMessage *message) {
            [lastLogs addObject:message.message];
        }];
        [DDLog addLogger:blockBlogger];
    });

    afterEach(^{
        [DDLog removeLogger:blockBlogger];
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
});

describe(@"check setting log levels", ^{
    it(@"should change log level", ^{
        struct AUTLogContext AUTLogKitTestContext = { .level = AUTLogLevelOff };
        
        AUTLogContextSetLevel(&AUTLogKitTestContext, AUTLogLevelError);
        expect(AUTLogKitTestContext.level).to.equal(AUTLogLevelError);
    });
    
    it(@"should have a different unique identifier", ^{
        struct AUTLogContext AUTLogKitTestContext1 = { .level = AUTLogLevelOff };
        struct AUTLogContext AUTLogKitTestContext2 = { .level = AUTLogLevelOff };
        
        NSUInteger AUTLogKitTestContext1Identifier = AUTLogContextGetIdentifier(&AUTLogKitTestContext1);
        NSUInteger AUTLogKitTestContext2Identifier = AUTLogContextGetIdentifier(&AUTLogKitTestContext2);
        
        expect(AUTLogKitTestContext1Identifier).notTo.equal(AUTLogKitTestContext2Identifier);
    });
});

SpecEnd
