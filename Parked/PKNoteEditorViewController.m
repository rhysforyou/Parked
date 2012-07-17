//
//  PKNoteEditorViewController.m
//  Parked
//
//  Created by Rhys Powell on 16/07/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import "PKNoteEditorViewController.h"
#import "PKParkingDetails.h"

@interface PKNoteEditorViewController ()

@end

@implementation PKNoteEditorViewController
@synthesize textView = _textView;
@synthesize parkingDetails = _parkingDetails;

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didShowKeyboard:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didHideKeyboard)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    self.textView.text = self.parkingDetails.notes;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.parkingDetails.notes = self.textView.text;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Events

- (void)didShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
}

- (void)didHideKeyboard
{
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
