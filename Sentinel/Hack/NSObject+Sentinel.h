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
