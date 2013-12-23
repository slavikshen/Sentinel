//
//  UIApplication+Sentinel.m
//  Youplay
//
//  Created by Slavik on 12/21/13.
//  Copyright (c) 2013 apollobrowser.com. All rights reserved.
//

#import "UIApplication+Sentinel.h"
#import "NSObject+Sentinel.h"

//@interface AppActivitySentinal : NSObject
//
//+ (AppActivitySentinal*)appSentinal;
//
//- (void)start;
//
//@end
//
//@implementation AppActivitySentinal
//
//+ (AppActivitySentinal*)appSentinal {
// 
//    static AppActivitySentinal* inst = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        inst = [[AppActivitySentinal alloc] init];
//    });
//    
//    return inst;
//}
//
//- (void) start {
//    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self
//           selector:@selector(_appEnterForeground)
//               name:UIApplicationWillEnterForegroundNotification
//             object:nil];
//    [nc addObserver:self
//           selector:@selector(_appEnterBackground)
//               name:UIApplicationDidEnterBackgroundNotification
//             object:nil];
//}
//
//- (void)_appEnterForeground {
//    [self sentinelLogEvent:@"{\"event\":\"app_enter_foreground\"}"];
//}
//
//- (void)_appEnterBackground {
//    [self sentinelLogEvent:@"{\"event\":\"app_enter_background\"}"];    
//}
//
//@end

@implementation UIApplication (Sentinel)

+ (void)load {
    [self swizzleMethod:@selector(openURL:) withMethod:@selector(_sentinal_openURL:)];
}

- (BOOL)_sentinal_openURL:(NSURL*)url {
    
    NSString* event = _F(@"{\"event\":\"openURL\",\"URL\":\"%@\"}", url.absoluteString);
    [self sentinelLogEvent:event];
    return [self _sentinal_openURL:url];
    
}

@end
