//
//  CategoryTableViewCell.h
//  Self-Track
//
//  Created by Duc Pham on 1/16/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewColor;
@property (weak, nonatomic) IBOutlet UILabel *lbDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbCategoryName;

@end
