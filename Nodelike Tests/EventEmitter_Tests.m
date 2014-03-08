//
//  EventEmitter_Tests.m
//  Nodelike
//
//  Created by Sam Rijs on 3/8/14.
//  Copyright (c) 2014 Sam Rijs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NLContext.h"
#import "NLNatives.h"

@interface EventEmitter_Tests : XCTestCase

@end

@implementation EventEmitter_Tests

- (void)testAll {
    NSString *prefix = @"test-event-emitter";
    [NLNatives.modules enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj hasPrefix:prefix]) {
            NSLog(@"running %@", obj);
            NLContext *ctx = [NLContext new];
            ctx.exceptionHandler = ^(JSContext *ctx, JSValue *e) {
                XCTFail(@"Context exception thrown: %@; stack: %@", e, [e valueForProperty:@"stack"]);
            };
            [ctx evaluateScript:@"require_ = require; require = (function (module) { return require_(module === '../common' ? 'test-common' : module); });"];
            [ctx evaluateScript:[NLNatives source:obj]];
            [NLContext runEventLoopSync];
            [ctx emitExit];
        }
    }];
}

@end
