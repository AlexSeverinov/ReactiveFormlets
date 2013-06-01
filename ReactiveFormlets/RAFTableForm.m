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

- (NSUInteger)numberOfSections
{
	return self.count;
}

- (RAFTableSection *)sectionAtIndex:(NSUInteger)index
{
	return self.allValues[index];
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
	return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self sectionAtIndex:section].title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [self sectionAtIndex:section].footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self sectionAtIndex:section].numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self sectionAtIndex:indexPath.section] cellForRow:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self rowAtIndexPath:indexPath] willDisplayCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RAFInputRow *row = [self rowAtIndexPath:indexPath];
	[row.rowWasSelected execute:row];
}

@end


@implementation RAFSingleSectionTableForm {
	RAFTableSection *_section;
}

- (RAFTableSection *)sectionAtIndex:(NSUInteger)index {
	if (!_section) {
		_section = [[[[[RAFTableSection model:self.class.model] alloc] initWithOrderedDictionary:self] title:self.title] footerTitle:self.footerTitle];
	}

	return _section;
}

@end
