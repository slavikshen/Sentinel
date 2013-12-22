//
//  UICollectionView+Sentinel.m
//  Sentinel
//
//  Created by Slavik on 12/20/13.
//  Copyright (c) 2013 Slavik. All rights reserved.
//

#import "UICollectionView+Sentinel.h"
#import "NSObject+Sentinel.h"

@implementation UICollectionView (Sentinel)

+ (void)load {
    
    [self swizzleMethod:NSSelectorFromString(@"_deselectItemAtIndexPath:animated:notifyDelegate:")
             withMethod:@selector(_sentinel_deselectItemAtIndexPath:animated:notifyDelegate:)];
    [self swizzleMethod:NSSelectorFromString(@"_selectItemAtIndexPath:animated:scrollPosition:notifyDelegate:")
             withMethod:@selector(_sentinel_selectItemAtIndexPath:animated:scrollPosition:notifyDelegate:)];
    
}

- (BOOL)sentinelEnabledInTheClass {
    return YES;
}

- (void)_sentinel_selectItemAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(CGPoint)pos notifyDelegate:(BOOL)notifyDelegate {
    
    [self _sentinel_selectItemAtIndexPath:indexPath animated:animated scrollPosition:pos notifyDelegate:notifyDelegate];
    if( [self sentinelEnabledInTheClass] ) {
        NSString* identification = [self sentinalObjectIdentification];
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSString* event = [NSString stringWithFormat:@"{\"event\":\"select\", \"indexPath\":{\"section\":\"%d\",\"row\":\"%d\"}, \"sender\": %@}", section, row, identification];
        [self sentinelLogEvent:event];
    }
    
}

- (void)_sentinel_deselectItemAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated notifyDelegate:(BOOL)notifyDelegate {
    
    [self _sentinel_deselectItemAtIndexPath:indexPath animated:animated notifyDelegate:notifyDelegate];
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
