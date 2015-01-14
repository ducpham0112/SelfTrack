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


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnStart:(id)sender;

@property BOOL isTracking;
@property (strong, nonatomic) NSString* trackingCategory;
@property (strong, nonatomic) NSDate* startTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateTable" object:nil];
    _listCategory = [CoreDataFunctions listCategoryWithDuration];
    
    NSUserDefaults* preference = [NSUserDefaults standardUserDefaults];
    _isTracking = [preference boolForKey:@"DistanceType"] || NO;
    _trackingCategory = [preference stringForKey:@"TrackingCategory"];
    _startTime = [preference objectForKey:@"StartTime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateTable {
    _listCategory = [CoreDataFunctions listCategoryWithDuration];
    //NSPredicate *p = [NSPredicate predicateWithFormat:@"(name == %@)", @"Test2"];
    //_listCategory = [_listCategory filteredArrayUsingPredicate:p];
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
    static NSString* CellIdentifier = @"cellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary* category = [_listCategory objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ duration: %@", [category objectForKey:@"name"], [category objectForKey:@"duration"]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([CoreDataFunctions getIndexOfCategoryWithName:_trackingCategory] == indexPath.row && _isTracking){
        if ([CoreDataFunctions addNewTimeWithStarttime:_startTime endTime:[NSDate date] inCategoryWithName:_trackingCategory]) {
            _isTracking = NO;
            _trackingCategory = nil;
            _startTime = nil;
            NSLog(@"Stop");
        }
        // alert else clause
        
        return;
    }
    else {
        if (_isTracking){
        [CoreDataFunctions addNewTimeWithStarttime:_startTime endTime:[NSDate date] inCategoryWithName:_trackingCategory];
        }
        _isTracking = YES;
        _startTime = [NSDate date];
        NSDictionary* selectedCategory = [_listCategory objectAtIndex:indexPath.row];
        _trackingCategory = [selectedCategory objectForKey:@"name"];
        NSLog(@"Start");
        
    }
}

# pragma mark - functions
- (IBAction)btnStart:(id)sender {
    
}

@end
