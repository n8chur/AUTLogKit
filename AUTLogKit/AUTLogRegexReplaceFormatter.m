//
//  AUTLogRegexReplaceFormatter.m
//  AUTLogKit
//
//  Created by Eric Horacek on 3/8/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTLogRegexReplaceFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTLogRegexReplaceFormatter ()

@property (readonly, nonatomic) NSRegularExpression *regularExpression;
@property (readonly, nonatomic, copy) AUTLogRegexMatchReplaceBlock matchReplaceBlock;

@end

@implementation AUTLogRegexReplaceFormatter

- (instancetype)init AUT_UNAVAILABLE_DESIGNATED_INITIALIZER;

- (instancetype)initWithRegularExpression:(NSRegularExpression *)regularExpression matchReplaceBlock:(AUTLogRegexMatchReplaceBlock)matchReplaceBlock {
    AUTAssertNotNil(regularExpression, matchReplaceBlock);

    self = [super init];

    _regularExpression = regularExpression;
    _matchReplaceBlock = [matchReplaceBlock copy];

    return self;
}

- (nullable NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    let message = logMessage.message;
    let range = NSMakeRange(0, logMessage.message.length);
    let matchResults = [self.regularExpression matchesInString:logMessage.message options:0 range:range];
    if (matchResults.count == 0) return message;

    NSMutableString *mutableMessage = [message mutableCopy];
    NSInteger offset = 0;

    for (NSTextCheckingResult *matchResult in matchResults) {
        var resultRange = matchResult.range;
        resultRange.location += offset;

        var replacement = [self.regularExpression
            replacementStringForResult:matchResult
            inString:mutableMessage
            offset:offset
            template:@"$0"];

        replacement = self.matchReplaceBlock(replacement);

        [mutableMessage replaceCharactersInRange:resultRange withString:replacement];

        offset += (replacement.length - resultRange.length);
    }

    return [mutableMessage copy];
}

@end

NS_ASSUME_NONNULL_END
