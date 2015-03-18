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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property BOOL isEdit;

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
    
    if (_isEdit) {
        [self.colorPicker setColor:(UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:[_category objectForKey:@"color"]]];
        _navItem.title = [_category objectForKey:@"name"];
        _navItem.rightBarButtonItem.title = @"Save";
        _tfCategoryName.text = [_category objectForKey:@"name"];
        //_navItem.rightBarButtonItem = nil;
    }
    else {
        [self.colorPicker setColor:[self randomColor]];
        _navItem.title = @"New Category";
        _navItem.rightBarButtonItem.title = @"Add";
        //_tfCategoryName.text = [_category objectForKey:@"name"];
    }
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
- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (id) initWithCategory:(NSDictionary*) category{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddNewCategoryViewController* categoryVC = [storyboard instantiateViewControllerWithIdentifier:@"categoryViewController"];
    categoryVC.category = category;
    categoryVC.isEdit = true;
    return categoryVC;
}

- (IBAction)doneBtnClicked:(id)sender {
    [_tfCategoryName resignFirstResponder];
    if (_isEdit){
        if ([CoreDataFunctions editCategoryWithName:[_category objectForKey:@"name"]  withNewName:_tfCategoryName.text hasColor:self.colorPicker.color]){
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Something wrong! Please try again." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        if ([CoreDataFunctions addNewCategoryWithName:_tfCategoryName.text withChartColor:self.colorPicker.color]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Something wrong! Please try again." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            [alert show];
        }
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
