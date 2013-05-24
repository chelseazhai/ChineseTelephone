//
//  ContactListTabContentView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

@interface ContactListTabContentView : UITableView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AddressBookChangedDelegate> {
    // all contacts info array in addressBook reference
    NSMutableArray *_mAllContactsInfoArrayInABRef;
    
    // present contacts info array reference
    NSMutableArray *_mPresentContactsInfoArrayRef;
    
    // selected cell indexPath
    NSIndexPath *_mSelectedCellIndexPath;
    
    // contact search bar
    UISearchBar *_mContactSearchBar;
}

@property (nonatomic, readonly) NSMutableArray *allContactsInfoArrayInABRef;

@property (nonatomic, retain) NSMutableArray *presentContactsInfoArrayRef;

@end
