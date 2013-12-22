//
//  SKPaymentQueue+Sentinel.m
//  Youplay
//
//  Created by Slavik on 12/21/13.
//  Copyright (c) 2013 apollobrowser.com. All rights reserved.
//

#import "SKPaymentQueue+Sentinel.h"
#import "NSObject+Sentinel.h"

@implementation SKPaymentQueue (Sentinel)

+ (void)load {
    
    [self swizzleMethod:@selector(addPayment:)
             withMethod:@selector(_sentinel_addPayment:)];
    [self swizzleMethod:@selector(finishTransaction:)
             withMethod:@selector(_sentinel_finishTransaction:)];
    
}

- (void)_sentinel_addPayment:(SKPayment *)payment {
    
    NSString* pid = payment.productIdentifier;
    NSString* event = _F(@"{\"event\":\"SKPaymentQueue_add\",\"id\":\"%@\"}",pid);
    [self sentinelLogEvent:event];
    
    [self _sentinel_addPayment:payment];    
}

- (void)_sentinel_finishTransaction:(SKPaymentTransaction *)transaction {
 
    NSString* pid = transaction.payment.productIdentifier;
    SKPaymentTransactionState state = transaction.transactionState;
    NSString* stateName = nil;
    switch(state) {
        case SKPaymentTransactionStatePurchased:
            stateName=@"purchased";
            break;
        case SKPaymentTransactionStateFailed:
            stateName=@"failed";
            break;
        case SKPaymentTransactionStateRestored:
            stateName=@"restored";
            break;
        default:
            break;
    }

    NSString* event = _F(@"{\"event\":\"SKPaymentQueue_finish\",\"id\":\"%@\",\"state\":\"%@\"}",pid, stateName);
    [self sentinelLogEvent:event];
    
    [self _sentinel_finishTransaction:transaction];
    
}

@end
