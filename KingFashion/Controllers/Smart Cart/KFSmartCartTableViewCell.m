//
//  KFSmartCartTableViewCell.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/19/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFSmartCartTableViewCell.h"

@interface KFSmartCartTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemPreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;


@end

@implementation KFSmartCartTableViewCell

- (void)setItem:(KFSmartCartItem *)item {
    self.itemPreviewImageView.image = item.image;
    self.itemPriceLabel.text = [NSString stringWithFormat:@"$%.2f", item.price];
    self.itemNameLabel.text = item.name;
}

@end
