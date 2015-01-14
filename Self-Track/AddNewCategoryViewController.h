//
//  AddNewCategoryViewController.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewCategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfCategoryName;
- (IBAction)addCategory:(id)sender;

@end
