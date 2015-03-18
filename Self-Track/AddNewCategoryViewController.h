//
//  AddNewCategoryViewController.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"
#import "CategoryTracked.h"

@interface AddNewCategoryViewController : UIViewController <UIAlertViewDelegate>
@property(nonatomic, strong) NSDictionary* category;

@property (weak, nonatomic) IBOutlet UITextField *tfCategoryName;
- (IBAction)doneBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIView *pickedColor;

- (id) initWithCategory:(NSDictionary*) category;
@end
