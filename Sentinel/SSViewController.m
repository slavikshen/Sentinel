//
//  SSViewController.m
//  Sentinel
//
//  Created by Slavik on 12/6/13.
//  Copyright (c) 2013 Slavik. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()

@property(nonatomic,strong) NSArray* tests;

@end

@implementation SSViewController

- (NSArray*)tests {
 
    if( nil == _tests ) {
        _tests = @[@"SSRedViewController",@"SSBlueViewController"];
    }
    
    return _tests;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sential Statistic";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* tests = self.tests;
    NSInteger count = tests.count;

    return count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* tests = self.tests;
    NSInteger row = [indexPath row];
    NSString* className = tests[row];
    
    static NSString* CELL_ID = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CELL_ID];
    }
    cell.textLabel.text = className;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSArray* tests = self.tests;
    NSInteger row = [indexPath row];
    NSString* className = tests[row];
    
    NSLog(@"select %@", className);
    
    UIViewController* v = [[NSClassFromString(className) alloc] init];
    v.title = className;
    [self.navigationController pushViewController:v animated:YES];
    
}


@end
