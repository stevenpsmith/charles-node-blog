//
//  CSMViewController.m
//  OpenWeatherMap
//
//  Created by Steve Smith on 1/8/14.
//  Copyright (c) 2014 Steve Smith. All rights reserved.
//

#import "CSMDayWeatherViewController.h"
#import "CSMServerAPI.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CSMDayWeatherViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivConditionIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblConditionText;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblMinTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblHighTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end

@implementation CSMDayWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[CSMServerAPI sharedInstance] weatherForLongitude:-75.1914 andLatitude:40.1386 successBlock:^(NSDictionary *weatherDict) {
        NSLog(@"Weather: %@", weatherDict);
        NSString *location = [weatherDict objectForKey:@"name"];

        NSDictionary *weather = [[weatherDict objectForKey:@"weather"] firstObject];
        NSString *condition = [weather objectForKey:@"main"];
        NSString *iconId = [weather objectForKey:@"icon"];
        
        NSDictionary *details = [weatherDict objectForKey:@"main"];
        long temp = [self convertToFahrenheitFromKelvin:[[details objectForKey:@"temp"] longValue]];
        long lowTemp = [self convertToFahrenheitFromKelvin:[[details objectForKey:@"temp_min"] longValue]];
        long highTemp = [self convertToFahrenheitFromKelvin:[[details objectForKey:@"temp_max"] longValue]];
        
        [_lblLocation setText:location];
        [_lblConditionText setText:condition];
        [_lblCurrentTemp setText:[NSString stringWithFormat:@"%ld", temp]];
        [_lblHighTemp setText:[NSString stringWithFormat:@"%ld", highTemp]];
        [_lblMinTemp setText:[NSString stringWithFormat:@"%ld", lowTemp]];
        [_ivConditionIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", iconId]]];
        [MBProgressHUD hideAllHUDsForView:[self view] animated:YES];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:[self view] animated:YES];
        NSDictionary *userInfo = [error userInfo];
        NSString *msg = [NSString stringWithFormat:@"%@ - %@", [userInfo objectForKey:CSMNetworkingErrorKey], [userInfo objectForKey:CSMNetworkingErrorMessageKey]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Houston - We have a Problem" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetFields];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
    [hud setLabelText:@"Loading..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (long)convertToFahrenheitFromKelvin:(long)kelvinTemp {
    return ((kelvinTemp - 273) * 1.8) + 32;
}

- (void)resetFields {
    [_lblLocation setText:@""];
    [_lblConditionText setText:@""];
    [_lblCurrentTemp setText:@"--"];
    [_lblHighTemp setText:@""];
    [_lblMinTemp setText:@""];
    [_ivConditionIcon setImage:nil];
}

@end
