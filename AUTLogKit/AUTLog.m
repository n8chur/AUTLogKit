//
//  AUTLog.m
//  AUTLogKit
//
//  Created by Sylvain Rebaud on 7/14/15.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

@import Foundation;
#import <libkern/OSAtomic.h>

#import "AUTLog.h"
#import "AUTExtObjC.h"
#import "AUTLog_Private.h"

NS_ASSUME_NONNULL_BEGIN

/// A dictionary representing the context identifiers mapped by their
/// corresponding context name to ensure only one context can have a given name.
static NSMutableDictionary<NSString *, NSNumber *> *registeredContexts;

@interface AUTLogContext ()

@property (readwrite, atomic, copy) NSString *name;

@end

@implementation AUTLogContext

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registeredContexts = [NSMutableDictionary dictionary];
    });
}

- (instancetype)init AUT_UNAVAILABLE_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString *)name level:(AUTLogLevel)level {
    NSParameterAssert(name != NULL);

    @synchronized(registeredContexts) {
        // Assert if another context was already registered with same name
        NSAssert(registeredContexts[name] == nil, @"Context '%@' already registered", name);
        
        self = [super init];
        
        _level = level;
        _name = [name copy];
        
        registeredContexts[name] = @(self.identifier);
        
        return self;
    }
}

- (AUTLogContextIdentifier)identifier {
    return (AUTLogContextIdentifier)self;
}

+ (nullable AUTLogContext *)contextForIdentifier:(AUTLogContextIdentifier)identifier {
    @synchronized(registeredContexts) {
        // Verify the context identifier is a valid context and not an arbitrary
        // value.
        if (![registeredContexts.allValues containsObject:@(identifier)]) return nil;
        
        return (__bridge AUTLogContext *)(void *)identifier;
    }
}

+ (NSArray<AUTLogContext *> *)registeredContexts {
    @synchronized(registeredContexts) {
        let contextIdentifiers = registeredContexts.allValues;
        NSMutableArray<AUTLogContext *> *contexts = [NSMutableArray arrayWithCapacity:contextIdentifiers.count];
        
        // Map context identifiers to contexts
        [contextIdentifiers enumerateObjectsUsingBlock:^(NSNumber *contextIndentifier, NSUInteger idx, BOOL *stop) {
            let context = [self contextForIdentifier:contextIndentifier.integerValue];
            [contexts addObject:context];
        }];
        
        return [contexts copy];
    }
}

+ (void)resetRegisteredContexts {
    @synchronized(registeredContexts) {
        registeredContexts = [NSMutableDictionary dictionary];
    };
}

@end

NS_ASSUME_NONNULL_END
