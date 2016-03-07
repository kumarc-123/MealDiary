//
//  ViewController.m
//  MealDiary
//
//  Created by Kumar C on 3/2/16.
//  Copyright © 2016 Kumar C. All rights reserved.
//

#import "ViewController.h"
#import "WebPageVCtr.h"
#import "HUDUtil.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSInteger selectedRow;
}

@property (nonatomic, strong) NSDictionary *mainMenu;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mainMenu = @{
                  @"Call now"               : @"tel:+91-789-981-0010",
                  @"Home"                   : @"http://mealdiaries.com/index.php/home",
                  @"Menu"                   : @"http://mealdiaries.com/index.php/home",
                  @"Why Meals Diaries"      : @"http://mealdiaries.com/index.php/why-mealdiaries",
                  @"How It Works?"          : @"http://mealdiaries.com/index.php/how-it-works",
                  @"Celebration Diaries"    : @"http://mealdiaries.com/index.php/home",
                  @"Contact Us"             : @"http://mealdiaries.com/index.php/contacts",
                  @"Terms and Conditions"   : @"http://mealdiaries.com/index.php/terms-and-conditions"
                  };
    
    _titles = @[@"Call now", @"Home", @"Menu", @"Why Meals Diaries", @"How It Works?", @"Celebration Diaries", @"Contact Us", @"Terms and Conditions"];
    
    selectedRow = -1;
    
    self.title = @"MEAL DIARIES";

//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UILabel *title = (UILabel *) [cell viewWithTag:100];
    
    title.text = [_titles objectAtIndex:indexPath.row];
    
    if (indexPath.row == selectedRow) {
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:152 / 255.0 blue:164 / 255.0 alpha:1];
    }
    else
    {
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

//- (void) viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillAppear:animated];
//
//}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
    [super viewDidAppear:animated];
    [HUDUtil hideProgressHUD:self];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mainMenu count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger prevRow = selectedRow;
    selectedRow = indexPath.row;
    if (prevRow == -1) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:prevRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (indexPath.row != 0) {
        [HUDUtil showBlockingHUD:self];
        [self performSegueWithIdentifier:@"menu_to_web" sender:[_titles objectAtIndex:indexPath.row]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want call Meal Diaries \n(+91) 7899810010?" delegate:self cancelButtonTitle:@"Call now" otherButtonTitles:@"Later", nil];
        [alert show];
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = -1;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:[_mainMenu valueForKey:[_titles objectAtIndex:0]]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Can't make a call to \n(+91) 7899810010?" delegate:nil cancelButtonTitle:@"Call now" otherButtonTitles:@"Later", nil];
            [alert show];
        }
    }
    selectedRow = -1;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"menu_to_web"]) {
        WebPageVCtr *pageVCtr = [segue destinationViewController];
        pageVCtr.pageTitle = (NSString *) sender;
        pageVCtr.webUrl = [NSURL URLWithString:[_mainMenu valueForKey:(NSString *) sender]];
        
        [HUDUtil hideProgressHUD:self];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
