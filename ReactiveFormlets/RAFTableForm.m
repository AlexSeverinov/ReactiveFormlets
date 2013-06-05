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

@implementation RAFTableForm

- (UITableView *)buildView {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	tableView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.f];

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
