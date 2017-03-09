//
//  AUTLogTimestampFormatterSpec.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import AUTLogKit;

#import "AUTExtObjC.h"

SpecBegin(AUTLogTimestampFormatter)

it(@"should prepend date", ^{
    let logFormatter = [[AUTLogTimestampFormatter alloc] init];

    let date = [NSDate dateWithTimeIntervalSince1970:0];

    let logMessage = [[DDLogMessage alloc]
        initWithMessage:@"foo"
        level:DDLogLevelInfo
        flag:DDLogFlagInfo
        context:2
        file:nil
        function:nil
        line:0
        tag:nil
        options:0
        timestamp:date];

    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"1969/12/31 16:00:00:000 foo");
});

SpecEnd
