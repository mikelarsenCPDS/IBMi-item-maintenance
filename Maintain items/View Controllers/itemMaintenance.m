//
//  itemMaintenance.m
//  Maintain items
//
//  Created by Michael D Larsen on 9/3/18.
//  Copyright © 2018 Smash Alley, LLC. All rights reserved.
//

#import "itemMaintenance.h"

@interface itemMaintenance ()

@end

@implementation itemMaintenance

{
    sendItemModel *_sendItemModel;
    
    NSMutableArray *itemArray;
    NSMutableArray *itemJsonArray;
    NSDictionary   *itemJsonDictionary;
    
    // fields returned from the send item info web service
    
    NSString *itemStatus;
    NSArray *downloadedItems;
    
    NSArray *arrWSResponseMessage;
    NSString *strWSResponseMessage;
    
    NSArray *arrWSMessage;
    NSString *strWSMessage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // initialize the mutable arrays
    
    itemArray = [[NSMutableArray alloc] init];
    itemJsonArray = [[NSMutableArray alloc] init];
    
    ///_txtItemNumber.layer.borderColor = [[UIColor blackColor]CGColor];
    
    //_txtItemNumber.layer.borderWidth = 1.0;
    
    UIColor *color = [[UIColor alloc]initWithRed:229.0/255.0 green:237.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    _itemView.backgroundColor = color;
    
    //[itemScrollView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnOk:(id)sender
{
    // when they click the 'ok' button, consume the IBM i web service passing the item array
    
    itemJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                         _txtItemNumber.text,@"inItemNumber",
                         _txtItemDescription.text,@"inItemDescription",
                         _txtUnitOfMeasure.text,@"inUnitOfMeasure",
                         _txtItemClass.text,@"inItemClass",
                         nil];
    
    [itemJsonArray addObject:itemJsonDictionary];
    
    [self sendItemInfo];
}

- (void)sendItemInfo
{
    // ------------------------------------------------------------------------------------------------------------
    // POST ITEM
    // ------------------------------------------------------------------------------------------------------------
    
    // Create new sendItem object and assign it to sendItem variable
    
    _sendItemModel = [[sendItemModel alloc] init];
    
    // Set this view controller object as the delegate for the sendItem model object
    
    _sendItemModel.delegate = self;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Call the sendItem method of the _sendItemModel model object
    
    [_sendItemModel sendItem:itemJsonArray];
}

-(void)sendItemResponseWS:(NSArray *)ItemsDownloaded
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    
    downloadedItems = ItemsDownloaded;
    
    sendItemInfo *sendItemInfo = downloadedItems[0];
    
    // i will only populate the response if:
    //
    // 1.  you couldn't connect to the service
    // 2.  there are actual items to download
    
    if (downloadedItems == nil || [downloadedItems count] == 0)
    {
        
    }
    else
    {
        arrWSResponseMessage = [downloadedItems valueForKey:@"WSResponseMessage"];
        
        strWSResponseMessage = sendItemInfo.WSResponseMessage;
        
        // this is the info coming from the rpg web service
        
        itemStatus = sendItemInfo.sendItemStatus;
    }
    
    if ([strWSResponseMessage isEqualToString:@"Can't connect to server"])
    {
        // after calling web service, you need to call dispatch_async on anything UI related otherwise it hangs
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // if you get a bad response from the server, put up an alert
            
            [self connectionToServerAlert];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        });
    }
    else
    {
        // after calling web service, you need to call dispatc_async on anything UI related otherwise it hangs
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // if you get a good response from the server, put up an alert showing
            // the status of the item maintained
            
            [self itemStatusAlert];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

- (void)connectionToServerAlert
{
    UIAlertController *alert =   [UIAlertController
                                  alertControllerWithTitle:@"Connection issue"
                                  message:@"Can't connect to server"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)itemStatusAlert
{
    UIAlertController *alert =   [UIAlertController
                                  alertControllerWithTitle:@"Item Status"
                                  message:itemStatus
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
