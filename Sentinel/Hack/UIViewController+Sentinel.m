//
//  UIViewController+Sentinel.m
//  Youplay
//
//  Created by Slavik on 12/17/13.
//  Copyright (c) 2013 apollobrowser.com. All rights reserved.
//

#import "UIViewController+Sentinel.h"
#import "NSObject+Sentinel.h"

@implementation UIViewController (Sentinel)

+ (void)load {
    
    [self swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(_sentinelViewDidAppear:)];
    [self swizzleMethod:@selector(viewDidDisappear:) withMethod:@selector(_sentinelViewDidDisappear:)];
    
}

- (void)_sentinelViewDidAppear:(BOOL)animated {
    
    [self _sentinelViewDidAppear:animated];
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSString* event = [@"{\"event\":\"enter\",\"arg\":" stringByAppendingString:identification];
        [self sentinelLogEvent:event];
    }
    
}

- (void)_sentinelViewDidDisappear:(BOOL)animated {
    
    [self _sentinelViewDidDisappear:animated];
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSString* event = [@"{\"event\":\"leave\",\"arg\":" stringByAppendingString:identification];
        [self sentinelLogEvent:event];
    }
    
}

- (BOOL)sentinelEnabledInTheClass {

    if( [self isKindOfClass:[UINavigationController class]] ||
        [self isKindOfClass:[UIPopoverController class]] ||
        [self isKindOfClass:[UITabBarController class]] ) {
        return NO;
    }
    return YES;
}

- (NSString*)sentinalObjectIdentification {
 
    NSString* title = self.title;
    NSString* className = NSStringFromClass([self class]);
    
    NSString* identification = nil;
    if( title.length ) {
        identification = _F(@"{\"class\":\"%@\",\"title\":\"%@\"}", className, title);
    } else {
        identification = _F(@"{\"class\":\"%@\"}", className);
    }
    return identification;
}

@end


