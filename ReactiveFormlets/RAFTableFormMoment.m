//
//  RAFTableFormMoment.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFTableFormMoment.h"
#import "RAFTableSectionMoment.h"

@implementation RAFTableFormMoment

- (id)initWithSectionMoments:(NSArray *)sections {
	if (self = [super init]) {
		_sectionMoments = [sections copy];
	}

	return self;
}

- (NSIndexPath *)indexPathForRow:(RAFTableRow *)row {
	__block NSIndexPath *indexPath = nil;
	[self.sectionMoments enumerateObjectsUsingBlock:^(RAFTableSectionMoment *controller, NSUInteger sectionIndex, BOOL *stop) {
		if ([controller.rows containsObject:row]) {
			*stop = YES;
			indexPath = [NSIndexPath indexPathForRow:[controller.rows indexOfObject:row] inSection:sectionIndex];
		}
	}];

	return indexPath;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.sectionMoments[indexPath.section] rows][indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionMoments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.sectionMoments[section] rows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.sectionMoments[indexPath.section] rows][indexPath.row] cell];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sectionMoments[section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [self.sectionMoments[section] footerTitle];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self.sectionMoments[indexPath.section] rows][indexPath.row] rowWasSelected];
}

@end