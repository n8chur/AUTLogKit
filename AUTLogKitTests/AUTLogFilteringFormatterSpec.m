//
//  AUTLogFilteringFormatterSpec.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import AUTLogKit;

#import "AUTExtObjC.h"

SpecBegin(AUTLogFilteringFormatter)

let CreateLogMessage = ^(DDLogLevel level, DDLogFlag flag, NSInteger context) {
    return [[DDLogMessage alloc]
        initWithMessage:@"foo"
        level:level
        flag:flag
        context:context
        file:@(__FILE__)
        function:@(__FUNCTION__)
        line:0
        tag:nil
        options:0
        timestamp:nil];
};

it(@"should not filter messages that do not have contexts", ^{
    let includingLevelsByContextID = @{ @1: @(AUTLogLevelOff) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];
    
    let logMessage = CreateLogMessage(DDLogLevelInfo, DDLogFlagInfo, 0);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should filter message not within the included contexts", ^{
    let includingLevelsByContextID = @{ @1: @(AUTLogLevelAll) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];

    let logMessage = CreateLogMessage(DDLogLevelInfo, DDLogFlagInfo, 2);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.beNil();
});

it(@"should filter messages that are below the highest allowed log level", ^{
    NSUInteger context = 1;
    let includingLevelsByContextID = @{ @(context): @(AUTLogLevelError) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];

    let logMessage = CreateLogMessage(DDLogLevelInfo, DDLogFlagInfo, context);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.beNil();
});

it(@"should not filter messages that meet the highest allowed log level", ^{
    NSUInteger context = 1;
    let includingLevelsByContextID = @{ @(context): @(AUTLogLevelInfo) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];

    let logMessage = CreateLogMessage(DDLogLevelInfo, DDLogFlagInfo, context);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should not filter messages that exceed the highest allowed log level", ^{
    NSUInteger context = 1;
    let includingLevelsByContextID = @{ @(context): @(AUTLogLevelInfo) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];

    let logMessage = CreateLogMessage(DDLogLevelError, DDLogFlagError, context);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

it(@"should not filter message with non excluded context", ^{
    NSUInteger context = 1;
    let includingLevelsByContextID = @{ @(context): @(AUTLogLevelAll) };
    let logFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:includingLevelsByContextID];

    let logMessage = CreateLogMessage(DDLogLevelInfo, DDLogFlagInfo, context);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).toNot.beNil();
});

SpecEnd
