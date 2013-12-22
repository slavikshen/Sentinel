//
//  SKRequest+Sentinel.m
//  Youplay
//
//  Created by Slavik on 12/21/13.
//  Copyright (c) 2013 apollobrowser.com. All rights reserved.
//

#import "SKRequest+Sentinel.h"
#import "NSObject+Sentinel.h"

@implementation SKRequest (Sentinel)

+ (void)load {
 
    [self swizzleMethod:@selector(start)
             withMethod:@selector(_sentinel_start)];
    [self swizzleMethod:@selector(cancel)
             withMethod:@selector(_sentinel_cancel)];

}

- (void)_sentinel_start {
    [self sentinelLogEvent:@"{\"event\":\"SKRequest_start\"}"];
    [self _sentinel_start];
}

- (void)_sentinel_cancel {
    [self sentinelLogEvent:@"{\"event\":\"SKRequest_cancel\"}"];
    [self _sentinel_cancel];
}

@end
