//
//  ListCategoryTableViewController.m
//  Self-Track
//
//  Created by Duc Pham on 3/16/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "ListCategoryTableViewController.h"
#import "CategoryTableViewCell.h"
#import "CoreDataFunctions.h"
#import "AddNewCategoryViewController.h"

@interface ListCategoryTableViewController ()

@end

@implementation ListCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateTable" object:nil];
    _listCategory = [CoreDataFunctions listCategoryWithDuration:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"categoryCell"];
    

}

- (void) updateTable {
    _listCategory = [CoreDataFunctions listCategoryWithDuration:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
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
    cell.lbDuration.text = [NSString stringWithFormat:@""];
    cell.viewColor.backgroundColor = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:[category objectForKey:@"color"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddNewCategoryViewController* categoryVC = [[AddNewCategoryViewController alloc] initWithCategory:[_listCategory objectAtIndex:indexPath.row]];
    [self.navigationController showViewController:categoryVC sender:self];
}

@end
