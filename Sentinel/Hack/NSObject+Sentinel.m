//
//  NSObject+Sentinel.m
//  Sentinel
//
//  Created by Slavik on 12/20/13.
//  Copyright (c) 2013 Slavik. All rights reserved.
//

#import <objc/runtime.h>

#ifdef FLURRY_ID
#import "Flurry+LogAfx.h"
#import "JSONKit.h"
#else
#import "Sentinel.h"
#endif

@implementation NSObject (Sentinel)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if (origMethod && newMethod) {
        if (class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

#ifdef  DEBUG

+ (void)leakMethods:(Class)c {
    
    unsigned int count = 0;
	Method *array = class_copyMethodList( c, &count);
	DLog(@"got method count:%d", count);
	for(int i = 0 ; i < count ; i++){
		Method method = array[i];
		SEL methodselector = method_getName(method);
		const char* methodname = sel_getName(methodselector);
		unsigned int argcount = method_getNumberOfArguments(method);
		NSString *mn = [NSString stringWithCString:methodname encoding:NSASCIIStringEncoding];
		DLog(@"selector name:%@ (%d)", mn, argcount);
	}
}

#endif

+ (void)prepareKagemusha:(Class)c methodMap:(NSDictionary*)map {
    
    unsigned int count = 0;
	Method *array = class_copyMethodList( c, &count);
	for(int i = 0 ; i < count ; i++){
		Method method = array[i];
		SEL methodselector = method_getName(method);
		const char* methodname = sel_getName(methodselector);
		NSString *mn = [NSString stringWithCString:methodname encoding:NSASCIIStringEncoding];
        NSString* newName = [map objectForKey:mn];
        if( newName ) {
	        IMP method_imp = method_getImplementation(method);
            SEL selector = NSSelectorFromString(newName);
        	if(method_imp){
				class_addMethod([UIDatePicker class], selector, method_imp, method_getTypeEncoding(method));
                break;
			}
        }
	}
    
}

- (void)sentinelLogEvent:(NSString*)event {
    
#ifdef FLURRY_ID
    
    NSDictionary* json = [event objectFromJSONString];
    
    NSString* eventName = json[@"event"];
    
    if( nil == eventName ) {
        return;
    }
    
    NSDictionary* sender = json[@"sender"];
    NSString* className = sender[@"class"];
    NSDictionary* delegate = sender[@"delegate"];
    NSDictionary* datasource = sender[@"datasource"];

    NSMutableString* flurryEventName = [NSMutableString stringWithString:eventName];;
    
    if( className.length ) {
        [flurryEventName appendString:@":"];
        [flurryEventName appendString:className];
    }
    if( delegate ) {
        [flurryEventName appendString:@"+"];
        [flurryEventName appendString:delegate[@"class"]];
    }
    if( datasource ) {
        [flurryEventName appendString:@"+"];
        [flurryEventName appendString:datasource[@"class"]];
    }
    
    UIDevice* currentDevice = [UIDevice currentDevice];
	NSString* systemVersion = [currentDevice systemVersion];
	NSString* systemModel = [currentDevice platform];
	NSString* deviceId = [currentDevice deviceId];
	
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithDictionary:json];
    
    args[@"sysVer"] = systemVersion;
    args[@"model"] = systemModel;
    args[@"deviceId"] = deviceId;
    
    [Flurry logEvent:flurryEventName withParameters:args];
    
#else
    [[Sentinel sharedInstance] appendLog:event];
#endif
   
}

- (BOOL)sentinelEnabledInTheClass {
    return NO;
}

- (NSString*)sentinalObjectIdentification {
    
    NSString* className = NSStringFromClass([self class]);
    
    NSString* identification = _F(@"{\"class\":\"%@\"}", className);
    
    return identification;
}


@end
