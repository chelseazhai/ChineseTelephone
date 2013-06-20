//
//  CallRecordHistoryListTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordHistoryListTabContentView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "CallRecordDetailInfoViewController.h"

#import "CallRecordHistoryListTableViewCell.h"

#import "CallRecordBean.h"

#import "OutgoingCallGenerator.h"

@interface CallRecordHistoryListTabContentView ()

// edit call records
- (void)editCallRecords;

@end

@implementation CallRecordHistoryListTabContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"call record history list tab content view navigation title", nil);
        
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"call record history list tab item title", nil) image:[UIImage imageNamed:@"img_tab_callrecord"] tag:0];
        
        // set call record history list table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // set exit call records as right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCallRecords)];
        
        //
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

- (void)getCallRecordsFromDB{
    // check and init or clear call records info array
    if (nil == _mCallRecordsInfoArrayRef) {
        // init call records info array
        _mCallRecordsInfoArrayRef = [[NSMutableArray alloc] init];
    }
    else {
        // clear call records info array
        [_mCallRecordsInfoArrayRef removeAllObjects];
    }
    
    // open Chinese telephone database and checked it
    FMDatabase *_ChineseTelehoneDatabase = [FMDatabase databaseWithPath:[APP_DOCUMENTSPATH stringByAppendingPathComponent:CHINESETELEPHONE_DATABASENAME]];
    if ([_ChineseTelehoneDatabase open]) {
        // query all call records from call records table
        FMResultSet *_resultSet = [_ChineseTelehoneDatabase executeQuery:[NSString stringWithFormat:QUERYALLCALLRECORDSSTATEMENT, CALLRECORDS_TABLENAME, CALLRECORDSTABLE_DATE_FIELDNAME]];
        
        // process each call record in query result set
        while ([_resultSet next]) {
            // init new call record bean
            CallRecordBean *_callRecordBean = [[CallRecordBean alloc] init];
            
            // get each call record record field value
            sqlite_int64 _rowId = [_resultSet longLongIntForColumn:CALLRECORDSTABLE_ROWID_FIELDNAME];
            NSString *_name = [_resultSet stringForColumn:CALLRECORDSTABLE_NAME_FIELDNAME];
            NSString *_phone = [_resultSet stringForColumn:CALLRECORDSTABLE_PHONE_FIELDNAME];
            NSDate *_date = [_resultSet dateForColumn:CALLRECORDSTABLE_DATE_FIELDNAME];
            long _duration = [_resultSet longForColumn:CALLRECORDSTABLE_DUDATION_FIELDNAME];
            int _callFlags = [_resultSet intForColumn:CALLRECORDSTABLE_FLAGS_FIELDNAME];
            
//            NSLog(@"row id = %lld, name = %@, phone = %@, date = %@, duration = %ld and call flags = %d", _rowId, _name, _phone, _date, _duration, _callFlags);
            
            // set call record attributes with corresponding column field value
            _callRecordBean.rowId = _rowId;
            _callRecordBean.name = _name;
            _callRecordBean.phone = _phone;
            _callRecordBean.date = _date;
            _callRecordBean.duration = _duration;
            _callRecordBean.callType = _callFlags;
            
            // add call record bean to all call records info array
            [_mCallRecordsInfoArrayRef addObject:_callRecordBean];
        }
    }
    else {
        NSLog(@"open Chinese telephone database failed for query all call records");
    }
    
    // close Chinese telephone database
    [_ChineseTelehoneDatabase close];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mCallRecordsInfoArrayRef count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Call record cell";
    
    // get call record history list table view cell
    CallRecordHistoryListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[CallRecordHistoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    // get call record bean
    CallRecordBean *_callRecordBean = [_mCallRecordsInfoArrayRef objectAtIndex:indexPath.row];
    
    // set cell attributes
    _cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    _cell.callType = _callRecordBean.callType;
    _cell.callName = _callRecordBean.name;
    _cell.callPhone = _callRecordBean.phone;
    _cell.callCreatedDate = _callRecordBean.date;
    
    return _cell;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [CallRecordHistoryListTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // get the select call record callRecordBean
    CallRecordBean *_selectCallRecordBean = [_mCallRecordsInfoArrayRef objectAtIndex:indexPath.row];
    
    // generate new outgoing call with contact
    [[[OutgoingCallGenerator alloc] initWithDependentView:[tableView cellForRowAtIndexPath:indexPath] andViewController:self.viewControllerRef] generateNewOutgoingCall:_selectCallRecordBean.name phones:[NSArray arrayWithObject:_selectCallRecordBean.phone]];
    
    // deselect the selected row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // init call record detail info view controller
    CallRecordDetailInfoViewController *_callRecordDetailInfoViewController = [[[CallRecordDetailInfoViewController alloc] init] setCallRecord:[_mCallRecordsInfoArrayRef objectAtIndex:indexPath.row]];
    
    // hide bottom bar when call record detail info view controller pushed in
    _callRecordDetailInfoViewController.hidesBottomBarWhenPushed = YES;
    
    // show selected call record detail info view
    [self.viewControllerRef.navigationController pushViewController:_callRecordDetailInfoViewController animated:YES];
}

// inner extension
- (void)editCallRecords{
    NSLog(@"edit call records");
    
    //
}

@end
