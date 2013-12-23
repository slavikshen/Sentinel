//
//  NSObject+Sentinel.h
//  Sentinel
//
//  Created by Slavik on 12/20/13.
//  Copyright (c) 2013 Slavik. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _F
#define _F(fmt,...) ([NSString stringWithFormat:fmt, ##__VA_ARGS__] ) 
#endif

#ifndef SRELEASE
#if __has_feature(objc_arc)
#define SRELEASE(x) { x = nil; }
#else
#define SRELEASE(x) { [x release]; x = nil; }
#endif
#endif

#ifndef SRETAIN
#if __has_feature(objc_arc)
#define SRETAIN(x) x
#else
#define SRETAIN(x) [x retain]
#endif
#endif

@interface NSObject (Sentinel)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

#ifdef DEBUG
+ (void)leakMethods:(Class)c;
#endif

+ (void)prepareKagemusha:(Class)c methodMap:(NSDictionary*)map;

- (BOOL)sentinelEnabledInTheClass;
- (NSString*)sentinalObjectIdentification;
- (void)sentinelLogEvent:(NSString*)event;

@end
