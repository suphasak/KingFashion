//
//  KFSmartCartItem.h
//  KingFashion
//
//  Created by Anh Vu Mai on 10/19/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFSmartCartItem : NSObject

// Designated initializer
- (instancetype)initWithName:(NSString *)name
                       price:(Float64)price
                   imageName:(NSString *)imageName
            textureImageName:(NSString *)textureImageName;

@property (nonatomic, copy, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) Float64 price;
@property (nonatomic, copy, readonly) NSString *textureImageName;

// Helper properties
@property (nonatomic, nullable, strong, readonly) UIImage *image;
@property (nonatomic, nullable, strong, readonly) UIImage *textureImage;

// Data aggregate
+ (NSArray<KFSmartCartItem *> *)allItems;

@end

NS_ASSUME_NONNULL_END
