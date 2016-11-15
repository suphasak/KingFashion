//
//  NSArray+FunctionalInterface.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "NSArray+FunctionalInterface.h"

@implementation NSArray (FunctionalInterface)

//-------------------------------------------------------------------------------------------------
#pragma mark - Enumerating
//-------------------------------------------------------------------------------------------------
- (void)makeObjectsPerformBlock:(void (^)(__kindof id, NSUInteger))block {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Mapping
//-------------------------------------------------------------------------------------------------
- (NSArray<id> *)mapObjectsUsingTransform:(__kindof id (^)(__kindof id object, NSUInteger index))transform {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i = 0; i < [self count]; ++i) {
        id mappedObject = transform(self[i], i);
        if (mappedObject) {
            [mappedArray addObject:mappedObject];
        } else {
            [mappedArray addObject:[NSNull null]];
        }
    }
    return mappedArray;
}

- (NSArray<id> *)mapObjectsUsingKey:(NSString *)key {
    return [self mapObjectsUsingTransform:^__kindof id(__kindof id object, NSUInteger index) {
        return [object valueForKeyPath:key];
    }];
}

+ (NSArray<id> *)mapRange:(NSRange)range usingTransform:(__kindof id (^)(NSUInteger))transform {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger i = range.location; i < range.location + range.length; ++i) {
        id mappedObject = transform(i);
        if (mappedObject) {
            [mappedArray addObject:mappedObject];
        } else {
            [mappedObject addObject:[NSNull null]];
        }
    }
    return mappedArray;
}

+ (NSArray<id> *)mapRangeOfSize:(NSUInteger)size usingTransform:(__kindof id (^)(NSUInteger))transform {
    return [self mapRange:NSMakeRange(0, size) usingTransform:transform];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Reducing
//-------------------------------------------------------------------------------------------------
- (id)reduceUsingReducer:(__kindof id (^)(__kindof id, __kindof id, NSUInteger))reducer
        withInitialValue:(__kindof id)initialValue {
    if (![self count]) {
        return initialValue;
    }

    __kindof id currentValue = initialValue;
    for (NSUInteger index = 0; index < [self count]; ++index) {
        currentValue = reducer(currentValue, self[index], index);
    }

    return currentValue;
}

- (id)reduceUsingReducer:(__kindof id (^)(__kindof id, __kindof id, NSUInteger))reducer {
    if (![self count]) {
        return nil;
    }

    return [[self subarrayWithRange:NSMakeRange(1, [self count] - 1)]
            reduceUsingReducer:reducer withInitialValue:[self firstObject]];
}

@end
