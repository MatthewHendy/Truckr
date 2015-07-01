//
//  LeftVC.m
//  Truckr
//
//  Created by Mac OS on 6/29/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "LeftVC.h"
#import "MapViewController.h"
#import "AppDelegate.h"

@interface LeftVC ()

@end

@implementation LeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (IBAction)logoutButton:(id)sender {
    
    //logout
    [PFUser logOut];
    
    //get the mapViewcontroller so I can perform the segue tot he login controller
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    MapViewController * mapVC = dele.mapVC;
    
    //NSLog(@"mapVC title is %@", mapVC.title);
    //NSLog(@"navC, the name is %@", navC.title);
    
    [dele.sidebarVC dismissSidebarViewController];
    
    [mapVC performSegueWithIdentifier:@"logout" sender:mapVC];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
