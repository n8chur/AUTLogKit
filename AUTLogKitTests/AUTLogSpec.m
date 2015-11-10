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

#import "AUTLog_Private.h"

SpecBegin(AUTLog)

__block NSMutableArray *lastLogs;
__block AUTBlockLogger *blockBlogger;

beforeEach(^{
    [AUTLogContext resetRegisteredContexts];
});

describe(@"register context", ^{
    it(@"should have no registered contexts initially", ^{
        NSArray *contexts = [AUTLogContext registeredContexts];
        expect(contexts.count).to.equal(0);
    });
    
    it(@"should not return a valid context", ^{
        expect([AUTLogContext contextForIdentifier:2]).to.beNil();
    });
    
    it(@"should return a valid context", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelOff);
        expect([AUTLogContext contextForIdentifier:AUTLogKitTestContext.identifier]).to.equal(AUTLogKitTestContext);
    });
    
    it(@"should fail when creating a context when a context already exists with the same name", ^{
        AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(AUTLogKitTestContext, AUTLogLevelOff, "foo");
        
        expect([AUTLogContext contextForIdentifier:AUTLogKitTestContext.identifier]).to.equal(AUTLogKitTestContext);
        
        expect(^{
            AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(AUTLogKitTestContextOther, AUTLogLevelOff, "foo");
            
            expect([AUTLogContext contextForIdentifier:AUTLogKitTestContextOther.identifier]).to.equal(AUTLogKitTestContextOther);
        }).to.raise(NSInternalInconsistencyException);
    });
});

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
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelOff);

        NSString *log = @"This is a log";
        AUTLogError(AUTLogKitTestContext, @"%@", log);
        
        expect(lastLogs).will.haveACountOf(0);
    });

    it(@"it should initially log errors", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelError);

        NSString *log = @"This is a log";
        AUTLogError(AUTLogKitTestContext, @"%@", log);
        
        expect(lastLogs).will.haveACountOf(1);
        expect(lastLogs.firstObject).will.equal(log);
    });

    it(@"it should initially log everything", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelAll);
        
        NSString *logError = @"This is a log error";
        AUTLogError(AUTLogKitTestContext, @"%@", logError);
        
        NSString *logInfo = @"This is a log info";
        AUTLogInfo(AUTLogKitTestContext, @"%@", logInfo);
        
        expect(lastLogs).will.haveACountOf(2);
        expect(lastLogs.firstObject).will.equal(logError);
        expect(lastLogs.lastObject).will.equal(logInfo);
    });

    it(@"it should log after level change from off to error", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelOff);
        
        NSString *logError = @"This is a log error that will not be logged";
        AUTLogError(AUTLogKitTestContext, @"%@", logError);
        
        AUTLogKitTestContext.level = AUTLogLevelError;

        NSString *anotherLogError = @"This is a log error that will be logged";
        AUTLogError(AUTLogKitTestContext, @"%@", anotherLogError);
        
        expect(lastLogs).will.haveACountOf(1);
        expect(lastLogs.firstObject).will.equal(anotherLogError);
    });

    it(@"it should stop logging after level change from error to off", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelError);
        
        NSString *logError = @"This is a log error that will be logged";
        AUTLogError(AUTLogKitTestContext, @"%@", logError);
        
        AUTLogKitTestContext.level = AUTLogLevelOff;

        NSString *anotherLogError = @"This is a log error that will not be logged";
        AUTLogError(AUTLogKitTestContext, @"%@", anotherLogError);
        
        expect(lastLogs).will.haveACountOf(1);
        expect(lastLogs.firstObject).will.equal(logError);
    });
});

describe(@"check setting log levels", ^{
    it(@"should change log level", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext, AUTLogLevelOff);
        
        AUTLogKitTestContext.level = AUTLogLevelError;
        
        expect(AUTLogKitTestContext.level).to.equal(AUTLogLevelError);
    });
    
    it(@"should have a different unique identifier", ^{
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext1, AUTLogLevelOff);
        AUTLOGKIT_CONTEXT_CREATE(AUTLogKitTestContext2, AUTLogLevelOff);
        
        NSInteger AUTLogKitTestContext1Identifier = AUTLogKitTestContext1.identifier;
        NSInteger AUTLogKitTestContext2Identifier = AUTLogKitTestContext2.identifier;
        
        expect(AUTLogKitTestContext1Identifier).notTo.equal(AUTLogKitTestContext2Identifier);
    });
});

SpecEnd
