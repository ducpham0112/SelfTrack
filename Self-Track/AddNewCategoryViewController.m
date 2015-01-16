//
//  AddNewCategoryViewController.m
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "AddNewCategoryViewController.h"
#import "CoreDataFunctions.h"
#import "NKOColorPickerView.h"

@interface AddNewCategoryViewController ()

@property(nonatomic, strong) NSArray        *sliceColors;
@end

@implementation AddNewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    [self.view addGestureRecognizer:tapGesture];
    
    __weak AddNewCategoryViewController *weakSelf = self;
    
    [self.colorPicker setDidChangeColorBlock:^(UIColor *color){
        [weakSelf setPickedColor];
    }];
    
    [self.colorPicker setTintColor:[UIColor darkGrayColor]];
    
    [self setPickedColor];
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
    if ([CoreDataFunctions addNewCategoryWithName:_tfCategoryName.text withChartColor:self.colorPicker.color]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Something wrong! Please try again." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:@"Dismiss", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setPickedColor
{
    self.pickedColor.layer.cornerRadius = 6;
    self.pickedColor.backgroundColor = self.colorPicker.color;
}

-(void) tapBackground{
    [_tfCategoryName resignFirstResponder];
}

@end
