//
//  KFSmartCartManager.h
//  KingFashion
//
//  Created by Anh Vu Mai on 10/21/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFSmartCartItem.h"

@interface KFSmartCartManager : NSObject

// Singleton initializer
+ (instancetype)sharedManager;

// Cart items
@property (nonatomic, strong, readonly) NSOrderedSet<KFSmartCartItem *> *smartCartItems;
- (void)addItem:(KFSmartCartItem *)item;
- (void)removeItem:(KFSmartCartItem *)item;

@end
