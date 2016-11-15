//
//  NSArray+FunctionalInterface.h
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (FunctionalInterface)

// Enumerating
- (void)makeObjectsPerformBlock:(void (^)(__kindof ObjectType object, NSUInteger index))block;

// Mapping
- (NSArray<id> *)mapObjectsUsingTransform:(__kindof id (^)(__kindof ObjectType object, NSUInteger index))transform;
- (NSArray<id> *)mapObjectsUsingKey:(NSString *)key;

+ (NSArray<id> *)mapRange:(NSRange)range usingTransform:(__kindof id (^)(NSUInteger value))transform;
+ (NSArray<id> *)mapRangeOfSize:(NSUInteger)size usingTransform:(__kindof id (^)(NSUInteger value))transform;

// Reducing
- (__kindof id)reduceUsingReducer:(__kindof id (^)(__kindof id previous, __kindof id current, NSUInteger currentIndex))reducer
                 withInitialValue:(__kindof id)initialValue;
- (__kindof id)reduceUsingReducer:(__kindof id (^)(__kindof id previous, __kindof id current, NSUInteger currentIndex))reducer;

@end
