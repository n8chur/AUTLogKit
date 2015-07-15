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

SpecBegin(AUTLog)

DDLogLevel ddLogLevel = DDLogLevelInfo;

AUTLogContext TestContext = &TestContext;

describe(@"it should log", ^{
    AUTLogError(TestContext, @"This is a log");
});

SpecEnd
