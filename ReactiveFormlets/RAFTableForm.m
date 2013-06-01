//
//  RAFTableForm.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableForm.h"
#import "RAFTableSection.h"
#import "RAFInputRow.h"

@implementation RAFTableForm {
	NSArray *_sectionHeaderViews;
	NSArray *_sectionFooterViews;
}

- (UITableView *)buildView {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	tableView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.f];

	_sectionHeaderViews = [self.sections.rac_sequence map:^id(RAFTableSection *section) {
		UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		CGRect frame = CGRectMake(0.f, 0.f, 320.f, 20.f);
		UIView *view = [[UIView alloc] initWithFrame:frame];
		view.autoresizingMask = mask;

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(frame, 10.f, 10.f)];
		label.autoresizingMask = mask;

		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:76.0/255 green:86.0/255 blue:108.0/255 alpha:1];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:17.f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.f, 1.f);
		RAC(label, text) = RACAbleWithStart(section, headerTitle);

		[view addSubview:label];

		return view;
	}].array;

	_sectionFooterViews = [self.sections.rac_sequence map:^id(RAFTableSection *section) {
		UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		CGRect frame = CGRectMake(0.f, 0.f, 320.f, 20.f);
		UIView *view = [[UIView alloc] initWithFrame:frame];
		view.autoresizingMask = mask;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(frame, 10.f, 10.f)];
		label.autoresizingMask = mask;

		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:76.0/255 green:86.0/255 blue:108.0/255 alpha:1];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:17.f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.f, 1.f);

		RAC(label, text) = RACAbleWithStart(section, footerTitle);
		[view addSubview:label];

		return view;
	}].array;

	tableView.dataSource = self;
	tableView.delegate = self;

	return tableView;
}

- (NSArray *)sections
{
	return self.allValues;
}

- (RAFTableSection *)sectionAtIndex:(NSUInteger)index
{
	return self.sections[index];
}

- (RAFInputRow *)rowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self sectionAtIndex:indexPath.section].allValues[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self rowAtIndexPath:indexPath].height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self sectionAtIndex:section].numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self sectionAtIndex:indexPath.section] cellForRow:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self sectionAtIndex:section].headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [self sectionAtIndex:section].footerTitle;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return _sectionHeaderViews[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return _sectionFooterViews[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = [self rowAtIndexPath:indexPath];
	[row.rowWasSelected execute:row];
}

@end


@implementation RAFSingleSectionTableForm {
	RAFTableSection *_section;
}

@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

- (RAFTableSection *)section {
	if (!_section) {
		_section = [[[RAFTableSection model:self.class.model] alloc] initWithOrderedDictionary:self];
		RAC(_section, headerTitle) = RACAbleWithStart(self.headerTitle);
		RAC(_section, footerTitle) = RACAbleWithStart(self.footerTitle);
	}

	return _section;
}

- (NSArray *)sections {
	return @[ self.section ];
}

- (RAFTableSection *)sectionAtIndex:(NSUInteger)index {
	return self.section;
}

@end
