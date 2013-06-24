//
//  RAFTableForm.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableForm.h"
#import "RAFTableSection.h"
#import "RAFTableRow.h"
#import "RAFObjCRuntime.h"
#import "EXTScope.h"

@interface RAFTableFormMoment : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong, readonly) NSArray *sections;

- (id)initWithSections:(NSArray *)sections;
- (NSIndexPath *)indexPathForRow:(RAFTableRow *)row;
@end

@interface RAFTableSectionMoment : NSObject
@property (copy, readonly) NSString *headerTitle;
@property (copy, readonly) NSString *footerTitle;
@property (copy, readonly) NSArray *rows;

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;
@end

@interface RAFTableForm ()
@property (strong) RAFTableFormMoment *tableController;
@end

@implementation RAFTableForm

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		_tableView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.f];
		self.sections = self.allValues;

		RAC(self.tableController) = [[[[RACAbleWithStart(self.sections) map:^id(NSArray *sections) {
			return [RACSignal combineLatest:[sections.rac_sequence map:^id(RAFTableSection *section) {
				NSArray *components = @[ RACAbleWithStart(section, rows), RACAbleWithStart(section, headerTitle), RACAbleWithStart(section, footerTitle) ];
				return [RACSignal combineLatest:components reduce:^(NSArray *rows, NSString *header, NSString *footer) {
					return [[RAFTableSectionMoment alloc] initWithRows:rows headerTitle:header footerTitle:footer];
				}];
			}]];
		}].switchToLatest map:^(RACTuple *sections) {
			return [[RAFTableFormMoment alloc] initWithSections:sections.rac_sequence.array];
		}] deliverOn:RACScheduler.mainThreadScheduler] startWith:[RAFTableFormMoment new]];

		self.tableView.dataSource = self.tableController;
		self.tableView.delegate = self.tableController;

		@weakify(self);
		[self.tableViewUpdatesSignal subscribeNext:^(RACTuple *tuple) {
			@strongify(self);
			RACTupleUnpack(RAFTableFormMoment *controller, NSIndexSet *sectionsToDelete, NSIndexSet *sectionsToInsert, NSArray *rowsToDelete, NSArray *rowsToInsert, NSArray *rowsToMove) = tuple;

			[self.tableView beginUpdates];

			[self.tableView deleteSections:sectionsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView insertSections:sectionsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];

			for (RACTuple *move in rowsToMove) {
				[self.tableView moveRowAtIndexPath:move.first toIndexPath:move.second];
			}

			self.tableView.dataSource = controller;
			self.tableView.delegate = controller;
			[self.tableView endUpdates];
		}];
	}

	return self;
}

- (RACSignal *)tableViewUpdatesSignal {
	return [RACAble(self.tableController) mapPreviousWithStart:self.tableController combine:^id(RAFTableFormMoment *oldController, RAFTableFormMoment *controller) {
		NSArray *oldSections = oldController.sections;
		NSArray *newSections = controller.sections;

		NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet indexSet];
		NSMutableIndexSet *sectionsToInsert = [NSMutableIndexSet indexSet];
		NSMutableArray *rowsToInsert = [NSMutableArray array];
		NSMutableArray *rowsToDelete = [NSMutableArray array];
		NSMutableArray *rowsToMove = [NSMutableArray array];

		[oldSections enumerateObjectsUsingBlock:^(RAFTableSectionMoment *section, NSUInteger sectionIndex, BOOL *stop) {
			[section.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				if (controller.sections.count <= sectionIndex) {
					[sectionsToDelete addIndex:sectionIndex];
				}

				if (![controller indexPathForRow:row]) {
					[rowsToDelete addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
				}
			}];
		}];

		[newSections enumerateObjectsUsingBlock:^(RAFTableSectionMoment *section, NSUInteger sectionIndex, BOOL *stop) {
			[section.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
				NSIndexPath *oldIndexPath = [oldController indexPathForRow:row];

				if (oldController.sections.count <= sectionIndex) {
					[sectionsToInsert addIndex:sectionIndex];
				}

				if (oldIndexPath) {
					[rowsToMove addObject:RACTuplePack(oldIndexPath, newIndexPath)];
				} else {
					[rowsToInsert addObject:newIndexPath];
				}
			}];
		}];

		return RACTuplePack(controller, [sectionsToDelete copy], [sectionsToInsert copy], [rowsToDelete copy], [rowsToInsert copy], [rowsToMove copy]);
	}];
}

@end

@implementation RAFOneSectionTableForm

+ (Protocol *)model {
	return @protocol(RAFIdentity);
}

+ (instancetype)section:(RAFTableSection *)section {
	return [(Class)self identityValue:section];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
	return [super methodSignatureForSelector:aSelector] ? nil : [(id<RAFIdentity>)self identityValue];
}

- (id)raf_extract {
	return [[super raf_extract] identityValue];
}

- (void)updateInPlace:(id)value {
	Class RAFIdentity = [RAFReifiedProtocol model:@protocol(RAFIdentity)];
	[super updateInPlace:[RAFIdentity identityValue:value]];
}

@end

@implementation RAFTableFormMoment

- (id)initWithSections:(NSArray *)sections {
	if (self = [super init]) {
		_sections = [sections copy];
	}

	return self;
}

- (NSIndexPath *)indexPathForRow:(RAFTableRow *)row {
	__block NSIndexPath *indexPath = nil;
	[self.sections enumerateObjectsUsingBlock:^(RAFTableSectionMoment *controller, NSUInteger sectionIndex, BOOL *stop) {
		if ([controller.rows containsObject:row]) {
			*stop = YES;
			indexPath = [NSIndexPath indexPathForRow:[controller.rows indexOfObject:row] inSection:sectionIndex];
		}
	}];

	return indexPath;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.sections[indexPath.section] rows][indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.sections[section] rows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.sections[indexPath.section] rows][indexPath.row] cell];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sections[section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [self.sections[section] footerTitle];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self.sections[indexPath.section] rows][indexPath.row] rowWasSelected];
}

@end

@implementation RAFTableSectionMoment

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
	if (self = [super init]) {
		_rows = [rows copy];
		_headerTitle = [headerTitle copy];
		_footerTitle = [footerTitle copy];
	}

	return self;
}

@end
