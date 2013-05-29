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
        _mContactSearchBar.barStyle = UIBarStyleBlack;
        _mContactSearchBar.keyboardType = UIKeyboardTypeASCIICapable;
        _mContactSearchBar.placeholder = NSLocalizedString(@"contact search bar placeholder", nil);
        
        // set contact search bar delegate
        _mContactSearchBar.delegate = self;
        
        // set contact search bar as contact list table view's header view
        self.tableHeaderView = _mContactSearchBar;
        
        // get all contacts info array from addressBook
        _mAllContactsInfoArrayInABRef = _mPresentContactsInfoArrayRef = [[AddressBookManager shareAddressBookManager].allContactsInfoArray phoneticsSortedContactsInfoArray];
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
        _cell = [[ContactListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
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
    NSMutableSet *_indices = [[NSMutableSet alloc] init];
    
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
        if ([_string1 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedDescending;
        }
        else if ([_string2 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedAscending;
        }
        else {
            _stringComparisonResult = [_string1 compare:_string2];
        }
        
        return _stringComparisonResult;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
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
    
    NSLog(@"did selected contact in table view = %@ and index path = %@", tableView, indexPath);
    
    //
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // dismiss soft input keyboard
    [_mContactSearchBar resignFirstResponder];
}

// UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"search bar = %@ and searched text = %@", searchBar, searchText);
    
    //
}

// AddressBookChangedDelegate
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver{
    //
}

// inner extension
- (void)addNewContact2AB{
    NSLog(@"Add new contact to address book");
}

@end
