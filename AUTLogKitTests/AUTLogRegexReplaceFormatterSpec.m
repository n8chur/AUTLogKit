//
//  AUTLogRegexReplaceFormatterSpec.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;
@import AUTLogKit;

#import "AUTExtObjC.h"

SpecBegin(AUTLogRegexReplaceFormatter)

__block NSError *error;

beforeEach(^{
    error = nil;
});

// Stars out any matches.
let StarOutMatchBlock = ^(NSString *match) {
    return [@"" stringByPaddingToLength:match.length withString:@"*" startingAtIndex:0];
};

let CreateLogMessage = ^(NSString *message) {
    return [[DDLogMessage alloc]
        initWithMessage:message
        level:DDLogLevelInfo
        flag:DDLogFlagInfo
        context:1
        file:@(__FILE__)
        function:@(__FUNCTION__)
        line:0
        tag:nil
        options:0
        timestamp:nil];
};

it(@"should replace matches in the log message", ^{
    let regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9]{3}\\b" options:0 error:&error];
    expect(error).to.beNil();

    let logFormatter = [[AUTLogRegexReplaceFormatter alloc] initWithRegularExpression:regex matchReplaceBlock:StarOutMatchBlock];
    
    let logMessage = CreateLogMessage(@"We want replace this 123 and this 345 but not a 12345");

    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"We want replace this *** and this *** but not a 12345");
});

it(@"should replace matches in the log message with shorter values", ^{
    let regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9]{3}\\b" options:0 error:&error];
    expect(error).to.beNil();

    let logFormatter = [[AUTLogRegexReplaceFormatter alloc] initWithRegularExpression:regex matchReplaceBlock:^(NSString *match) {
        return [match substringToIndex:1];
    }];
    
    let logMessage = CreateLogMessage(@"We want replace this 123 and this 345 but not a 12345");
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"We want replace this 1 and this 3 but not a 12345");
});

it(@"should replace matches in the log message with longer values", ^{
    let regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9]{3}\\b" options:0 error:&error];
    expect(error).to.beNil();

    let logFormatter = [[AUTLogRegexReplaceFormatter alloc] initWithRegularExpression:regex matchReplaceBlock:^(NSString *match) {
        return [match stringByPaddingToLength:(match.length * 2) withString:@"*" startingAtIndex:0];
    }];
    
    let logMessage = CreateLogMessage(@"We want add stars to 123 and this 345 but not a 12345");
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(@"We want add stars to 123*** and this 345*** but not a 12345");
});

it(@"should handle no matches", ^{
    let regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9]{6}\\b" options:0 error:&error];
    expect(error).to.beNil();

    let logFormatter = [[AUTLogRegexReplaceFormatter alloc] initWithRegularExpression:regex matchReplaceBlock:StarOutMatchBlock];

    let message = @"We don't want to replace 123 or 345";
    let logMessage = CreateLogMessage(message);
    
    let formattedMessage = [logFormatter formatLogMessage:logMessage];
    expect(formattedMessage).to.equal(message);
});

SpecEnd
