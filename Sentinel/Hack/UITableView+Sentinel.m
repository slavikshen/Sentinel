//
//  UITableView+Sentinel.m
//  Sentinel
//
//  Created by Slavik on 12/20/13.
//  Copyright (c) 2013 Slavik. All rights reserved.
//

#import "UITableView+Sentinel.h"
#import "NSObject+Sentinel.h"

@implementation UITableView (Sentinel)

+ (void)load {
    
    [self swizzleMethod:NSSelectorFromString(@"_deselectRowAtIndexPath:animated:notifyDelegate:")
             withMethod:@selector(_sentinel_deselectRowAtIndexPath:animated:notifyDelegate:)];
    [self swizzleMethod:NSSelectorFromString(@"_selectRowAtIndexPath:animated:scrollPosition:notifyDelegate:")
             withMethod:@selector(_sentinel_selectRowAtIndexPath:animated:scrollPosition:notifyDelegate:)];
    
}

- (BOOL)sentinelEnabledInTheClass {
    return YES;
}

- (void)_sentinel_selectRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(CGPoint)pos notifyDelegate:(BOOL)notifyDelegate {
 
    [self _sentinel_selectRowAtIndexPath:indexPath animated:animated scrollPosition:pos notifyDelegate:notifyDelegate];
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSString* event = [NSString stringWithFormat:@"{\"event\":\"select\", \"indexPath\":{\"section\":\"%d\",\"row\":\"%d\"}, \"sender\": %@}", section, row, identification];
        [self sentinelLogEvent:event];
    }
    
}

- (void)_sentinel_deselectRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated notifyDelegate:(BOOL)notifyDelegate {
    
    [self _sentinel_deselectRowAtIndexPath:indexPath animated:animated notifyDelegate:notifyDelegate];
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSString* event = [NSString stringWithFormat:@"{\"event\":\"deselect\", \"indexPath\":{\"section\":\"%d\",\"row\":\"%d\"}, \"sender\": %@}", section, row, identification];
        [self sentinelLogEvent:event];
    }
    
}

- (NSString*)sentinalObjectIdentification {
    
    id delegate = self.delegate;
    id datasource = self.dataSource;
    
    NSString* className = NSStringFromClass([self class]);
    
    NSMutableString* buf = [NSMutableString stringWithCapacity:128];
    [buf appendFormat:@"{\"class\":\"%@\"", className];
    
    if( delegate ) {
        NSString* delegateIdentification = [delegate sentinalObjectIdentification];
        [buf appendFormat:@",\"delegate\":%@", delegateIdentification];
    }
    if( datasource ) {
        NSString* dataSourceIdentification = [datasource sentinalObjectIdentification];
        [buf appendFormat:@",\"datasource\":%@", dataSourceIdentification];
    }
    
    [buf appendString:@"}"];
    
    return buf;
}


@end
