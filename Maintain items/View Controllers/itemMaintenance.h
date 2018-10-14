//
//  itemMaintenance.h
//  Maintain items
//
//  Created by Michael D Larsen on 9/3/18.
//  Copyright © 2018 Smash Alley, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sendItemModel.h"
#import "sendItemInfo.h"
#import <QuartzCore/QuartzCore.h>

@interface itemMaintenance : UIViewController <sendItemModelProtocol>

@property (strong, nonatomic) IBOutlet UITextField *txtItemNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtItemDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtUnitOfMeasure;
@property (strong, nonatomic) IBOutlet UITextField *txtItemClass;
- (IBAction)btnOk:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (strong, nonatomic) IBOutlet UIView *itemView;



@end
