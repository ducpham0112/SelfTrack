//
//  AddNewCategoryViewController.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"

@interface AddNewCategoryViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfCategoryName;
- (IBAction)addCategory:(id)sender;
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIView *pickedColor;


@end
