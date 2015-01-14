//
//  AddNewCategoryViewController.m
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "AddNewCategoryViewController.h"
#import "CoreDataFunctions.h"

@interface AddNewCategoryViewController ()

@end

@implementation AddNewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setTitle:@"Add New Category"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addCategory:(id)sender {
    [_tfCategoryName resignFirstResponder];
    if ([CoreDataFunctions addNewCategoryWithName:_tfCategoryName.text]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Something wrong! Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
