//
//  AddWeightViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AddWeightViewController.h"
#import "TextFieldTableViewCell.h"
#import "MHWeight.h"

@interface AddWeightViewController ()

@property (strong, nonatomic) TextFieldTableViewCell *dateCell;
@property (strong, nonatomic) UITextField *dateTextField;

@property (strong, nonatomic) TextFieldTableViewCell *weightCell;
@property (strong, nonatomic) UITextField *weightTextField;

@property (strong, nonatomic) NSDate *weightDate;

@end

@implementation AddWeightViewController

#pragma mark - View Lifecycle

- (void)loadView {
    [super loadView];
    
    // Set View as TableView
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.scrollEnabled = false;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.view = tableView;
    
    // Create Cells
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.date = [NSDate date];
    [datePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.dateCell = [[TextFieldTableViewCell alloc] init];
    self.dateCell.textField.placeholder = @"Date";
    self.dateCell.textField.inputView = datePicker;
    self.dateTextField = self.dateCell.textField;
    
    [self setDate:datePicker];
    
    self.weightCell = [[TextFieldTableViewCell alloc] init];
    self.weightCell.textField.placeholder = @"lbs";
    self.weightCell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.weightCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.weightTextField = self.weightCell.textField;
    
    // Set Navigation Bar
    
    self.title = @"Add Weight";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = save;
}


- (void)viewDidAppear:(BOOL)animated {
    [self.weightTextField becomeFirstResponder];
}

#pragma mark - Target-Action Methods

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)save {
    MHWeight *weight = [[MHWeight alloc] initWithWeight:self.weightTextField.text.doubleValue date:self.weightDate];
    
    [self.delegate addWeightViewController:self didAddWeight:weight];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setDate:(UIDatePicker *)datePicker {
    self.weightDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateTextField.text = [dateFormatter stringFromDate:self.weightDate];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return self.dateCell;
        }
        case 1: {
            return self.weightCell;
        }
        default:
            break;
    }
    
    return nil;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell.textField becomeFirstResponder];
}

@end
