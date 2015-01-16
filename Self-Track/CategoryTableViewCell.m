//
//  CategoryTableViewCell.m
//  Self-Track
//
//  Created by Duc Pham on 1/16/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _viewColor.layer.cornerRadius = 5;
}

@end
