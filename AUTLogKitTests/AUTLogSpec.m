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

struct AUTLogContext AUTLogKitTestContext = { .level   = AUTLogLevelOff };

describe(@"it should log", ^{
    AUTLogError(AUTLogKitTestContext, @"This is a log");
});

SpecEnd
