//
//  AUTLogContextNameFormatterSpec.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import AUTLogKit;
#import <AUTLogKit/AUTLog_Private.h>

#import "AUTExtObjC.h"

SpecBegin(AUTLogContextNameFormatter)

beforeEach(^{
    [AUTLogContext resetRegisteredContexts];
});

afterEach(^{
    [AUTLogContext resetRegisteredContexts];
});

it(@"should prepend context names", ^{
    AUTLOGKIT_CONTEXT_CREATE_WITH_NAME(AUTLogKitTestContext, AUTLogLevelOff, "TestContext");

    let logFormatter = [[AUTLogContextNameFormatter alloc] init];

    let identifier = AUTLogKitTestContext.identifier;

    let logMessage = [[DDLogMessage alloc]
        initWithMessage:@"foo"
        level:DDLogLevelInfo
        flag:DDLogFlagInfo
        context:identifier
        file:@(__FILE__)
        function:@(__FUNCTION__)
        line:0
        tag:nil
        options:0
        timestamp:nil];

    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"TestContext: foo");
});

SpecEnd
