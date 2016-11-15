//
//  KFSmartCartItem.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/19/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFSmartCartItem.h"

@implementation KFSmartCartItem

@synthesize image = _image;
@synthesize textureImage = _textureImage;

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (instancetype)initWithName:(NSString *)name
                       price:(Float64)price
                   imageName:(NSString *)imageName
            textureImageName:(nonnull NSString *)textureImageName {

    if (self = [super init]) {
        _name = name;
        _price = price;
        _imageName = imageName;
        _textureImageName = textureImageName;
    }
    return self;
}

- (UIImage *)image {
    if (!_image) {
        _image = [UIImage imageNamed:self.imageName];
    }
    return _image;
}

- (UIImage *)textureImage {
    if (!_textureImage) {
        _textureImage = [UIImage imageNamed:self.textureImageName];
    }
    return _textureImage;
}

+ (NSArray<KFSmartCartItem *> *)allItems {
    return @[[[KFSmartCartItem alloc] initWithName:@"Checkered Shirt"
                                             price:60
                                         imageName:@"top00"
                                  textureImageName:@"top00"],
             [[KFSmartCartItem alloc] initWithName:@"Brown Sweater"
                                             price:35
                                         imageName:@"top01"
                                  textureImageName:@"top01"],
             [[KFSmartCartItem alloc] initWithName:@"Navy Blue Polo Shirt"
                                             price:52.50
                                         imageName:@"top02"
                                  textureImageName:@"top02"],
             [[KFSmartCartItem alloc] initWithName:@"Polka Dot Brown Shirt"
                                             price:60
                                         imageName:@"top03"
                                  textureImageName:@"top03"],
             [[KFSmartCartItem alloc] initWithName:@"Striped Shirt"
                                             price:80
                                         imageName:@"top04"
                                  textureImageName:@"top04"]];
}

@end
