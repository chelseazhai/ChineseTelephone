//
//  ContactListTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListTabContentView.h"

#import "ContactListTableViewCell.h"

#import <CommonToolkit/CommonToolkit.h>

#import "OutgoingCallGenerator.h"

// phonetics indication string
#define PHONETICSINDIACATION_STRING  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

// contact search bar height
#define CONTACTSEARCHBAR_HEIGHT 46.0

@interface ContactListTabContentView ()

// add new contact to address book
- (void)addNewContact2AB;

@end

@implementation ContactListTabContentView

@synthesize allContactsInfoArrayInABRef = _mAllContactsInfoArrayInABRef;

@synthesize presentContactsInfoArrayRef = _mPresentContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"contact list tab content view navigation title", nil);
        
        // set add new contact as right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContact2AB)];
        
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"contact list tab item title", nil) image:[UIImage imageNamed:@"img_tab_contactlist"] tag:2];
        
        // create and init contact search bar
        _mContactSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, CONTACTSEARCHBAR_HEIGHT)];
        
        // set contact search bar style, keyboard type and placeholder
        _mContactSearchBar.barStyle = UIBarStyleBlackTranslucent;
        _mContactSearchBar.keyboardType = UIKeyboardTypeASCIICapable;
        _mContactSearchBar.placeholder = NSLocalizedString(@"contact search bar placeholder", nil);
        
        // set contact search bar delegate
        _mContactSearchBar.delegate = self;
        
        // set contact search bar as contact list table view's header view
        self.tableHeaderView = _mContactSearchBar;
        
        // get all contacts info array from addressBook
        _mAllContactsInfoArrayInABRef = _mPresentContactsInfoArrayRef = [[AddressBookManager shareAddressBookManager].allContactsInfoArray optPhoneticsSortedContactsInfoArray];
        // remove each contact extension dictionary
        for (ContactBean *_contact in _mAllContactsInfoArrayInABRef) {
            [_contact.extensionDic removeAllObjects];
        }
        
        // set contact list table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // add addressBook changed observer
        [[AddressBookManager shareAddressBookManager] addABChangedObserver:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mPresentContactsInfoArrayRef count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AB Contact cell";
    
    // get contact list table view cell
    ContactListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[ContactListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    // get contact bean
    ContactBean *_contactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    // set cell attributes
    _cell.photoImg = [UIImage imageWithData:_contactBean.photo];
    _cell.displayName = _contactBean.displayName;
    _cell.fullNames = _contactBean.fullNames;
    _cell.phoneNumbersArray = _contactBean.phoneNumbers;
    _cell.phoneNumberMatchingIndexs = [_contactBean.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS];
    _cell.nameMatchingIndexs = [_contactBean.extensionDic objectForKey:NAME_MATCHING_INDEXS];
    
    return _cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // define phonetics indication string array
    NSMutableSet *_indices = [[NSMutableSet alloc] initWithObjects:UITableViewIndexSearch, nil];
    
    // process present contacts info array
    for (ContactBean *_contact in _mPresentContactsInfoArrayRef) {
        // contact has name
        if ([_contact.namePhonetics count] > 0) {
            [_indices addObject:[[[[_contact.namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] uppercaseString]];
        }
        // contact has no name
        else {
            [_indices addObject:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]];
        }
    }
    
    return [[_indices allObjects] sortedArrayUsingComparator:^(NSString *_string1, NSString *_string2){
        NSComparisonResult _stringComparisonResult = NSOrderedSame;
        
        // compare
        if ([_string1 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]] || [_string2 isEqualToString:UITableViewIndexSearch]) {
            _stringComparisonResult = NSOrderedDescending;
        }
        else if ([_string1 isEqualToString:UITableViewIndexSearch] || [_string2 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedAscending;
        }
        else {
            _stringComparisonResult = [_string1 compare:_string2];
        }
        
        return _stringComparisonResult;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    // check title and index
    if ([title isEqualToString:UITableViewIndexSearch] && index == 0) {
        // scroll to top
        [self setContentOffset:CGPointZero animated:YES];
    }
    else {
        // process procent contacts info array
        for (NSInteger _index = 0; _index < [_mPresentContactsInfoArrayRef count]; _index++) {
            // 26 chars, 'ABCD...XYZ'
            if (![[title lowercaseString] isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
                // contact has name
                if ([((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] > 0) {
                    // get the matching contacts header
                    if ([[[[((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] compare:[title lowercaseString]] >= NSOrderedSame) {
                        // scroll to row at indexPath
                        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        
                        break;
                    }
                }
                // contact has no name
                else {
                    // scroll to row at indexPath
                    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    break;
                }
            }
            // '#'
            else {
                // contact has no name
                if ([((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] == 0) {
                    // scroll to row at indexPath
                    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    break;
                }
            }
        }
    }
    
    // default value
    return -1;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [ContactListTableViewCell cellHeightWithContact:[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // dismiss soft input keyboard
    [_mContactSearchBar resignFirstResponder];
    
    // get the select contact contactBean
    ContactBean *_selectContactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    // check select contact phone number array
    if (nil == _selectContactBean.phoneNumbers || 0 == [_selectContactBean.phoneNumbers count]) {
        // show contact has no phone number alertView
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"contact has no phone number alertView title", nil) message:_selectContactBean.displayName delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"contact has no phone number alertView reselect button title", nil), nil] show];
    }
    else {
        // generate new outgoing call with contact
        [[[OutgoingCallGenerator alloc] initWithDependentView:[tableView cellForRowAtIndexPath:indexPath] andViewController:self.viewControllerRef] generateNewOutgoingCall:_selectContactBean.displayName phones:_selectContactBean.phoneNumbers];
    }
    
    // deselect the selected row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // dismiss soft input keyboard
    [_mContactSearchBar resignFirstResponder];
}

// UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // check search parameter, check if or not nil or empty string
    if (nil == searchText || [@"" isEqualToString:searchText]) {
        // reset contact matching index array
        for (ContactBean *_contact in _mAllContactsInfoArrayInABRef) {
            [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
            [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
        }
        
        // show all contacts in addressBook
        _mPresentContactsInfoArrayRef = _mAllContactsInfoArrayInABRef;
    }
    else {
        // define temp array
        NSArray *_tmpArray = nil;
        
        // check search parameter again, check if or not contains none numeric character
        BOOL _isNumeric;
        if ((_isNumeric = [searchText isMatchedByRegex:@"^[0-9]+$"])) {
            // search by phone number
            _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByPhoneNumber:searchText];
        }
        else {
            // search by name
            _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByName:searchText];
        }
        
        // define searched contacts array
        NSMutableArray *_searchedContactsArray = [[NSMutableArray alloc] initWithCapacity:[_tmpArray count]];
        
        // compare seached contacts temp array contact with all contacts info array in addressBook contact
        for (ContactBean *_searchedContact in _tmpArray) {
            for (ContactBean *_contact in _mAllContactsInfoArrayInABRef) {
                // if the two contacts id is equal, add it to searched contacts array
                if (_contact.id == _searchedContact.id) {
                    [_searchedContactsArray addObject:_searchedContact];
                    
                    // check the search text is numeric and reset searched contact matching index array
                    if (_isNumeric) {
                        // remove name matching indexs
                        [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
                    }
                    else {
                        // remove phone number matching indexs
                        [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
                    }
                    
                    break;
                }
            }
        }
        
        // set addressBook contacts list view present contacts info array
        _mPresentContactsInfoArrayRef = _searchedContactsArray;
    }
    
    // reload addressBook contacts list table view data
    [self reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // dismiss soft input keyboard
    [_mContactSearchBar resignFirstResponder];
}

// AddressBookChangedDelegate
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver{
    // reset all contacts info array from address book and present contacts info array of addressBook contacts list table view
    NSArray *_newAllContactsInfoArrayInAB = [[AddressBookManager shareAddressBookManager].allContactsInfoArray optPhoneticsSortedContactsInfoArray];
    
    // process changed contact id array
    for (NSNumber *_contactId in [pInfo allKeys]) {
        // get action
        switch (((NSNumber *)[[pInfo objectForKey:_contactId] objectForKey:CONTACT_ACTION]).intValue) {
            case contactAdd:
            {
                // add to all contacts info array in addressBook reference
                for (NSInteger _index = 0; _index < [_newAllContactsInfoArrayInAB count]; _index++) {
                    if (((ContactBean *)[_newAllContactsInfoArrayInAB objectAtIndex:_index]).id == _contactId.integerValue) {
                        [_mAllContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_index] atIndex:_index];
                        
                        [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
                        
                        break;
                    }
                }
            }
                break;
                
            case contactModify:
            {
                // save the modify contact index of all contacts info array in addressBook reference and new temp all contacts info array in addressBook
                NSInteger _oldindex = 0, _newIndex = 0;
                for (NSInteger _index = 0; _index < [_mAllContactsInfoArrayInABRef count]; _index++) {
                    if (((ContactBean *)[_mAllContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
                        _oldindex = _index;
                        
                        _newIndex = [_newAllContactsInfoArrayInAB indexOfObject:[_mAllContactsInfoArrayInABRef objectAtIndex:_index]];
                        
                        break;
                    }
                }
                
                // check the two indexes
                if (_oldindex != _newIndex) {
                    [_mAllContactsInfoArrayInABRef removeObjectAtIndex:_oldindex];
                    [_mAllContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_newIndex] atIndex:_newIndex];
                }
                
                [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
            }
                break;
                
            case contactDelete:
            {
                // delete from all contacts info array in addressBook reference
                for (NSInteger _index = 0; _index < [_mAllContactsInfoArrayInABRef count]; _index++) {
                    if (((ContactBean *)[_mAllContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
                        [_mAllContactsInfoArrayInABRef removeObjectAtIndex:_index];
                        
                        [self searchBar:_mContactSearchBar textDidChange:_mContactSearchBar.text];
                        
                        break;
                    }
                }
            }
                break;
        }
    }
}

// ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    // clear address book new person view controller
    [[AddressBookUIUtils shareAddressBookUIUtils] clearABNewPersonViewController];
    
    // dismiss new person view controller
    [self.viewControllerRef.navigationController popToRootViewControllerAnimated:YES];
}

// inner extension
- (void)addNewContact2AB{
    // get address book new person view controller
    ABNewPersonViewController *_addressBookNewPersonViewController = [AddressBookUIUtils shareAddressBookUIUtils].addressBookNewPersonViewController;    
    
    // set its new person view delegate
    _addressBookNewPersonViewController.newPersonViewDelegate = self;
    
    // hide bottom bar when address book new person view controller pushed in
    _addressBookNewPersonViewController.hidesBottomBarWhenPushed = YES;
    
    // show add new contact to address book view controller
    [self.viewControllerRef.navigationController pushViewController:_addressBookNewPersonViewController animated:YES];
}

@end
