//
//  UIControl+Sentinel.m
//  Youplay
//
//  Created by Slavik on 12/21/13.
//  Copyright (c) 2013 apollobrowser.com. All rights reserved.
//

#import "UIControl+Sentinel.h"
#import "NSObject+Sentinel.h"

//NSArray* _sentinelControlEventName = nil;

@implementation UIControl (Sentinel)

+ (void)load {
//    
//    _sentinelControlEventName = [@[
//                                  @"TouchDown",
//                                  @"TouchDownRepeat",
//                                  @"TouchDragInside",
//                                  @"TouchDragOutside",
//                                  @"TouchDragEnter",
//                                  @"TouchDragExit",
//                                  @"TouchUpInside",
//                                  @"TouchUpOutside",
//                                  @"TouchCancel",
//                                  @"ValueChanged",
//                                  @"EditingDidBegin",
//                                  @"EditingChanged",
//                                  @"EditingDidEnd",
//                                  @"EditingDidEndOnExit",
//                                  ] retain];
//

    [self swizzleMethod:@selector(sendAction:to:forEvent:)
             withMethod:@selector(_sentinel_sendAction:to:forEvent:)];

    [self swizzleMethod:@selector(sendActionsForControlEvents:)
             withMethod:@selector(_sentinel_sendActionsForControlEvents:)];
    
}

- (BOOL)sentinelEnabledInTheClass {
    return YES;
}

- (void)_sentinel_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSString* targetID = [target sentinalObjectIdentification];

        NSString* selName = NSStringFromSelector(action);
        NSString* log = [NSString stringWithFormat:@"{\"event\":\"action\",\"name\":\"%@\",\"sender\":%@,\"target\":%@}", selName, identification, targetID];
        [self sentinelLogEvent:log];
    }
    
    [self _sentinel_sendAction:action to:target forEvent:event];
}

- (void)_sentinel_sendActionsForControlEvents:(UIControlEvents)controlEvents {
    
    if( [self sentinelEnabledInTheClass] && (controlEvents & [self allControlEvents] ) ) {
        
        NSString* identification = [self sentinalObjectIdentification];
        
        NSSet* targets = [self allTargets];
        for( id t in targets ) {
        
            NSString* targetID = [t sentinalObjectIdentification];
            
            NSArray* actions = [self actionsForTarget:t forControlEvent:controlEvents];
            for( NSString* selName in actions ) {
                
                NSString* event = [NSString stringWithFormat:@"{\"event\":\"action\",\"name\":\"%@\",\"sender\":%@,\"target\":%@}", selName, identification, targetID];
                [self sentinelLogEvent:event];
            }
            
        }
        
    }
    [self _sentinel_sendActionsForControlEvents:controlEvents];
    
}

@end
