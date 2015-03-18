//
//  ViewController.m
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataFunctions.h"
#import "CategoryTracked.h"
#import "CategoryTableViewCell.h"
#import "MyPieElement.h"
#import "PieLayer.h"
#import "AppDelegate.h"

#define PAGE_NUMBER 2
#define SCROLL_VIEW_WIDTH 300

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL isTracking;
@property (strong, nonatomic) NSString* trackingCategory;
@property (strong, nonatomic) NSDate* startTime;
@property (strong, nonatomic) NSArray* sliceColors;
@property (strong, nonatomic) NSUserDefaults* preference;

@property (strong, nonatomic) NSDictionary* selectedCategory;
@property (strong, nonatomic) NSIndexPath* selectedRow;

@property BOOL isWeeklyReport;

@property NSTimer* durationTimer;
- (IBAction)changeReportType:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateTable" object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    _isWeeklyReport = _segmentType.selectedSegmentIndex == 1;
    _listCategory = [CoreDataFunctions listCategoryWithDuration:_isWeeklyReport];
    
    _preference = [NSUserDefaults standardUserDefaults];
    _isTracking = [_preference boolForKey:@"IsTracking"] || NO;
    _trackingCategory = [_preference stringForKey:@"TrackingCategory"];
    _startTime = [_preference objectForKey:@"StartTime"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"categoryCell"];
    [self updatePieChart:YES];
    _lbCurCategoryName.alpha = 0;
    _lbCurDuration.alpha = 0;
    
}

-(void) orientationChanged {
    [self updatePieChart:NO];
}
-(void) updatePieChart:(BOOL) animated {
    [_myPieChart.layer deleteValues:[_myPieChart.layer values] animated:NO];
    for (NSDictionary* category in _listCategory) {
        double value = [[category objectForKey:@"duration"] doubleValue];
        UIColor* pieColor = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:[category objectForKey:@"color"]];
        MyPieElement* elem = [MyPieElement pieElementWithValue:value color:pieColor];
        
        [_myPieChart.layer addValues:@[elem] animated:animated | NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateTable {
    _listCategory = [CoreDataFunctions listCategoryWithDuration:_isWeeklyReport];
    [self updatePieChart:YES];
    [self.tableView reloadData];
}
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"categoryCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] init];
    }
    [self configureCell:(CategoryTableViewCell*)cell atIndexPath:indexPath];
    return  cell;
}

- (void) configureCell: (CategoryTableViewCell*) cell atIndexPath: (NSIndexPath*) indexPath {
    NSDictionary* category = [_listCategory objectAtIndex:indexPath.row];
    
    cell.lbCategoryName.text = [NSString stringWithFormat:@"%@", [category objectForKey:@"name"]];
    cell.lbDuration.text = [NSString stringWithFormat:@"%@", [category objectForKey:@"durationStr"]];
    cell.viewColor.backgroundColor = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:[category objectForKey:@"color"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCategory = [_listCategory objectAtIndex:indexPath.row];
    _selectedRow = indexPath;
    
    UITableViewCell* selectedCell = [_tableView cellForRowAtIndexPath:indexPath];
    selectedCell.backgroundColor = [UIColor lightGrayColor];
    
    if ([CoreDataFunctions getIndexOfCategoryWithName:_trackingCategory] == indexPath.row && _isTracking){
        NSString* message = [NSString stringWithFormat:@"Do you want to stop %@?", [_selectedCategory objectForKey:@"name"]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Stop Tracking" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 0;
        [alert show];

        // alert else clause
        
    }
    else {
        NSString* message = [NSString stringWithFormat:@"Do you want to start %@?", [_selectedCategory objectForKey:@"name"]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Start Tracking" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 1;
        [alert show];
        
    }
    [self save];
    return;
}

#pragma mark - scroll view delegate
/*- (void) GeneratePages {
    CGSize scrollViewSize = CGSizeMake(SCROLL_VIEW_WIDTH * PAGE_NUMBER, _scrollView.frame.size.height);
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView setContentSize:scrollViewSize];
    self.pageControl.numberOfPages = PAGE_NUMBER;
    for (int i = 0; i < PAGE_NUMBER; i++) {
        CGRect frame = _scrollView.frame;
        frame.size.width = SCROLL_VIEW_WIDTH;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0.0f;
        
        self.piechart.frame = frame;
 
        UILabel* lbValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        lbValue.text = [NSString stringWithFormat:@"Page %d", i];
        lbValue.backgroundColor = [UIColor clearColor];
        lbValue.textColor = [UIColor blackColor];
        lbValue.textAlignment = NSTextAlignmentCenter;
        lbValue.font = [UIFont fontWithName:@"Geeza Pro" size:25.0f];
        [page addSubview:lbValue];
 
        [_scrollView addSubview:self.piechart];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat viewWidth = scrollView.frame.size.width;
    
    int pageNumber = floor((scrollView.contentOffset.x - viewWidth/50) / viewWidth) + 1;
    self.pageControl.currentPage = pageNumber;
}

- (IBAction)pageChanged:(id)sender {
    long pageNumber = self.pageControl.currentPage;
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
    
    [_scrollView scrollRectToVisible:frame animated:YES];
}
*/

#pragma mark - functions
- (void) save {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.0);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [_preference setBool:_isTracking||NO forKey:@"IsTracking"];
        [_preference setObject:_trackingCategory forKey:@"TrackingCategory"];
        [_preference setObject:_startTime forKey:@"StartTime"];
    });
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    CategoryTableViewCell* selectedCell = (CategoryTableViewCell*)[_tableView cellForRowAtIndexPath:_selectedRow];
    selectedCell.backgroundColor = [UIColor whiteColor];
    
    switch (buttonIndex) {
        case 1:
            if (alertView.tag == 0){
                if ([CoreDataFunctions addNewTimeWithStarttime:_startTime endTime:[NSDate date] inCategoryWithName:[_selectedCategory objectForKey:@"name"]]) {
                    _isTracking = NO;
                    _trackingCategory = nil;
                    _startTime = nil;
                    NSLog(@"Stop");
                    
                    [[selectedCell layer] removeAnimationForKey:@"opacity"];
                    [_durationTimer invalidate];
                    [self updateTable];
                }
            } else if (alertView.tag == 1){
                NSDate* time = [NSDate date];
                if (_isTracking){
                    [CoreDataFunctions addNewTimeWithStarttime:_startTime endTime:time inCategoryWithName:_trackingCategory];
                }
                _isTracking = YES;
                _trackingCategory = [_selectedCategory objectForKey:@"name"];
                _startTime = time;
                NSLog(@"Start");
                
                [self blinkAnimation:selectedCell];
                _durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void) updateClock{
    CategoryTableViewCell* selectedCell = (CategoryTableViewCell*)[_tableView cellForRowAtIndexPath:_selectedRow];
    
    double curDuration = [CoreDataFunctions durationFrom:_startTime To:[NSDate date]] + [[[_listCategory objectAtIndex:_selectedRow.row] objectForKey:@"duration"] doubleValue];
    
    selectedCell.lbDuration.text = [CoreDataFunctions stringSecondFromInterval:curDuration];
}

- (void) blinkAnimation: (UIView*) view {
    CABasicAnimation *blinkAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [blinkAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [blinkAnimation setToValue:[NSNumber numberWithFloat:0.2]];
    [blinkAnimation setDuration:1.0f];
    [blinkAnimation setTimingFunction:[CAMediaTimingFunction
                                       functionWithName:kCAMediaTimingFunctionLinear]];
    [blinkAnimation setAutoreverses:YES];
    [blinkAnimation setRepeatCount:INT32_MAX];
    [[view layer] addAnimation:blinkAnimation forKey:@"opacity"];
}

- (IBAction)changeReportType:(id)sender {
    _isWeeklyReport = _segmentType.selectedSegmentIndex == 1;
    [self updateTable];
}
@end
