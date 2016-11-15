//
//  KFSmartCartManager.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/21/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFSmartCartManager.h"

@interface KFSmartCartManager ()

@property (nonatomic, strong, readonly) NSMutableOrderedSet<KFSmartCartItem *> *internalSmartCartItems;

@end

@implementation KFSmartCartManager

@synthesize internalSmartCartItems = _internalSmartCartItems;

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
/* Singleton implementation */
- (instancetype)init {
    NSString *exceptionReason = [NSString stringWithFormat:@"Singleton class %@ must not be instantiated, use singleton getter",
                                 NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:exceptionReason
                                 userInfo:nil];
    return nil;
}

- (instancetype)initForSingleton {
    self = [super init];

    if (self) {
        // Do additional setup over here

    }

    return self;
}

+ (instancetype)sharedManager {
    static KFSmartCartManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KFSmartCartManager alloc] initForSingleton];
    });
    return instance;
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Cart Data Manipulation
//-------------------------------------------------------------------------------------------------
- (NSMutableOrderedSet<KFSmartCartItem *> *)internalSmartCartItems {
    if (!_internalSmartCartItems) {
        _internalSmartCartItems = [NSMutableOrderedSet orderedSet];
    }
    return _internalSmartCartItems;
}

- (NSOrderedSet<KFSmartCartItem *> *)smartCartItems {
    return self.internalSmartCartItems;
}

- (void)addItem:(KFSmartCartItem *)item {
    [self.internalSmartCartItems addObject:item];
}

- (void)removeItem:(KFSmartCartItem *)item {
    [self.internalSmartCartItems removeObject:item];
}

@end
