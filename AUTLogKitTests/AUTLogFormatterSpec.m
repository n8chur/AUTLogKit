//
//  AUTLogFormatterSpec.m
//  Automatic
//
//  Created by Sylvain Rebaud on 7/16/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import ReactiveCocoa;
@import AUTLogKit;

#import "AUTLogFormatter.h"

SpecBegin(AUTLogFormatter)

__block NSError *error;
__block AUTLogFormatter *logFormatter;

beforeEach(^{
    logFormatter = nil;
    error = nil;
});

describe(@"lifecycle", ^{
    describe(@"deallocation", ^{
        it(@"should occur", ^{
            RACSignal *willDealloc;
            @autoreleasepool{
                AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient];
                willDealloc = logFormatter.rac_willDeallocSignal;
            }
            BOOL success = [willDealloc asynchronouslyWaitUntilCompleted:&error];
            expect(success).to.beTruthy();
            expect(error).to.beNil();
        });
    });
});

it(@"should not filter messages that do not have contexts", ^{
    NSDictionary *includedLevelsByContext = @{ @1: @(AUTLogLevelOff) };
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient includingLevelsByContext:includedLevelsByContext];
    
    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelInfo flag:DDLogFlagInfo context:0 file:nil function:nil line:0 tag:nil options:0 timestamp:nil];

    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should not filter message with context when no included log levels by context is set", ^{
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient];
    
    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelInfo flag:DDLogFlagInfo context:1 file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should filter message not within the included contexts", ^{
    NSDictionary *includedLevelsByContext = @{ @1: @(AUTLogLevelAll) };
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient includingLevelsByContext:includedLevelsByContext];

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelInfo flag:DDLogFlagInfo context:2 file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.beNil();
});

it(@"should filter message that do not reach a high enough level", ^{
    NSUInteger context = 1;
    NSDictionary *includedLevelsByContext = @{ @(context): @(AUTLogLevelError) };
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient includingLevelsByContext:includedLevelsByContext];

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelInfo flag:DDLogFlagInfo context:context file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.beNil();
});

it(@"should not filter messages that do not reach a high enough level", ^{
    NSUInteger context = 1;
    NSDictionary *includedLevelsByContext = @{ @(context): @(AUTLogLevelInfo) };
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient includingLevelsByContext:includedLevelsByContext];

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelError flag:DDLogFlagError context:context file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should not filter message with non excluded context", ^{
    NSUInteger context = 1;
    NSDictionary *includedLevelsByContext = @{ @(context): @(AUTLogLevelAll) };
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsClient includingLevelsByContext:includedLevelsByContext];

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:@"foo" level:DDLogLevelInfo flag:DDLogFlagInfo context:context file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should not prepend date", ^{
    NSString *message = @"foo";
    
    AUTLogFormatter *logFormatter = [[AUTLogFormatter alloc] initWithOptions:AUTLogFormatterOutputOptionsServer];
    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:message level:DDLogLevelInfo flag:DDLogFlagInfo context:2 file:nil function:nil line:0 tag:nil options:0 timestamp:nil];
    
    NSString *formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).equal(message);
});

SpecEnd