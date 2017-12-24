//
//  SettingsTableViewController.m
//  FourInLine
//
//  Created by Vasilii Muravev on 10.09.16.
//  Copyright © 2016 Vasilii Muravev. All rights reserved.
//

/*
#import "SettingsTableViewController.h"
#import "GameSettings.h"

@interface SettingsTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
@property (weak, nonatomic) IBOutlet UISlider *columnsSlider;
@property (weak, nonatomic) IBOutlet UISlider *linesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultiControl;
@property (weak, nonatomic) IBOutlet UISwitch *firstMoveSwitch;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initializeFetchedResultsController];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    [_managedObjectContext rollback]; // clear unsaved changes
    
    [self.columnsSlider setMaximumValue:maxNumOfColumns];
    [self.columnsSlider setMinimumValue:minNumOfColumns];
    [self.linesSlider setMaximumValue:maxNumOfLines];
    [self.linesSlider setMinimumValue:minNumOfLines];
        
    self.columnsSlider.value = _game.settings.numOfColumns;
    self.linesSlider.value = _game.settings.numOfLines;
    self.difficultiControl.selectedSegmentIndex = _game.settings.difficult;
    self.firstMoveSwitch.on = _game.settings.firstMoveHuman;
    
    [self.settingsTableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [NSString stringWithFormat:@"%d lines and %d columns", _game.settings.numOfLines, _game.settings.numOfColumns];
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFieldSizeFooter {
    [self.tableView beginUpdates];
    NSString *footer = [NSString stringWithFormat:@"%d lines and %d columns", _game.settings.numOfLines, _game.settings.numOfColumns];
    [self.tableView footerViewForSection:1].textLabel.text = footer;
    [self.tableView footerViewForSection:1].textLabel.numberOfLines = 1;
    [[self.tableView footerViewForSection:1].textLabel sizeToFit];
    [self.tableView endUpdates];
}

#pragma mark - Settings delegate

- (IBAction)saveSettingsTapped:(UIButton *)sender {
    if (![_managedObjectContext save:nil])
    {
        NSLog(@"Save did not complete successfully. Error: %@", @"");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)firstMoveChanged:(UISwitch *)sender {
    _game.settings.firstMoveHuman = sender.on;
}

- (IBAction)difficultiChanged:(UISegmentedControl *)sender {
    _game.settings.difficult = sender.selectedSegmentIndex;
}

- (IBAction)numOfLinesChanged:(UISlider *)slider {
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    _game.settings.numOfLines = index;
    [self updateFieldSizeFooter];
}

- (IBAction)numOfColumnsChanged:(UISlider *)slider {
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    _game.settings.numOfColumns = index;
    [self updateFieldSizeFooter];
}

#pragma mark - Table view data source


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
*/
