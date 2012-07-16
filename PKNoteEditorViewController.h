//
//  PKNoteEditorViewController.h
//  Parked
//
//  Created by Rhys Powell on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKParkingDetails;

@interface PKNoteEditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
