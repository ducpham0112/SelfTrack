//
//  ViewController.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPieViewLayer.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray* listCategory;
@property (weak, nonatomic) IBOutlet MyPieViewLayer *myPieChart;

@end

