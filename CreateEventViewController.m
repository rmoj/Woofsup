//
//  CreateEventViewController.m
//  Midterm (Storyboard)
//
//  Created by Viviane Chan on 2016-07-25.
//  Copyright © 2016 LightHouse Labs. All rights reserved.
//

#import "CreateEventViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface CreateEventViewController ()

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) NSString *dateFormat;
@property UITextField *activeField;
@property (nonatomic) CGFloat scrollViewCenterConstant;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDatePicker];
    [self registerForKeyboardNotifications];
}

#pragma mark - Save method

- (IBAction)saveData:(id)sender {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    //insert event
    Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    newEvent.eventTitle = self.eventTitle.text;
    newEvent.eventDescription = self.shortDescription.text;
    newEvent.eventAddress = self.eventAddress.text;
    newEvent.eventOrganizer = self.organizer.text;
    newEvent.eventDate = self.datePicker.date;
    [context save:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - Date Picker Handlers

- (void)setUpDatePicker {
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker setDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.eventDate setInputView:self.datePicker];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)sender {
    UIDatePicker *picker = (UIDatePicker *)self.eventDate.inputView;
    self.eventDate.text = [NSString stringWithFormat:@"%@",picker.date];
}

#pragma mark - Keyboard setup

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeField = textField;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height +10);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end