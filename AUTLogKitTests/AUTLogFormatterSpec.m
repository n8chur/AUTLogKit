//
//  AUTLogFormatterSpec.m
//  Automatic
//
//  Created by Sylvain Rebaud on 7/16/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import AUTLogKit;
@import CocoaLumberjack.DDMultiFormatter;
#import <AUTLogKit/AUTLog_Private.h>

#import "AUTExtObjC.h"

SpecBegin(AUTLogFormatter)

__block NSError *error;

beforeEach(^{
    [AUTLogContext resetRegisteredContexts];

    error = nil;
});

afterEach(^{
    [AUTLogContext resetRegisteredContexts];
});

it(@"should be composable", ^{
    let multiFormatter = [[DDMultiFormatter alloc] init];

    AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(AUTLogKitTestContext, AUTLogLevelOff, "MultiTestContext");
    AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(AUTLogKitTestOmittedContext, AUTLogLevelOff, "MultiTestOmittedContext");

    let filteringFormatter = [[AUTLogFilteringFormatter alloc] initWithIncludedLevelsByContextID:@{
        @(AUTLogKitTestContext.identifier): @(AUTLogLevelAll),
    }];

    let regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9]{3}\\b" options:0 error:&error];
    expect(error).to.beNil();
    let regexFormatter = [[AUTLogRegexReplaceFormatter alloc] initWithRegularExpression:regex matchReplaceBlock:^(NSString *match) {
        // Star out matches (e.g. 123 -> ***).
        return [@"" stringByPaddingToLength:match.length withString:@"*" startingAtIndex:0];
    }];

    let contextNameLogFormatter = [[AUTLogContextNameFormatter alloc] init];
    let timestampLogFormatter = [[AUTLogTimestampFormatter alloc] init];

    [multiFormatter addFormatter:filteringFormatter];
    [multiFormatter addFormatter:regexFormatter];
    [multiFormatter addFormatter:contextNameLogFormatter];
    [multiFormatter addFormatter:timestampLogFormatter];

    let date = [NSDate dateWithTimeIntervalSince1970:0];
    let identifier = AUTLogKitTestContext.identifier;

    let logMessage = [[DDLogMessage alloc]
        initWithMessage:@"foo 123"
        level:DDLogLevelInfo
        flag:DDLogFlagInfo
        context:identifier
        file:nil
        function:nil
        line:0
        tag:nil
        options:0
        timestamp:date];
    
    let formattedMessage = [multiFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"1969/12/31 16:00:00:000 MultiTestContext: foo ***");

    let omittedIdentifier = AUTLogKitTestOmittedContext.identifier;

    let omittedLogMessage = [[DDLogMessage alloc]
        initWithMessage:@"bar"
        level:DDLogLevelInfo
        flag:DDLogFlagInfo
        context:omittedIdentifier
        file:nil
        function:nil
        line:0
        tag:nil
        options:0
        timestamp:date];
    
    let omittedFormattedMessage = [multiFormatter formatLogMessage:omittedLogMessage];
    expect(omittedFormattedMessage).to.beNil();
});

SpecEnd
