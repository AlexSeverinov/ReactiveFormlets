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
#import "RAFTableFormMoment.h"
#import "RAFTableSectionMoment.h"

@interface RAFTableForm ()
@property (strong) RAFTableFormMoment *tableController;
@end

@implementation RAFTableForm

+ (Class)tableFormMomentClass {
	return [RAFTableFormMoment class];
}

+ (Class)tableSectionMomentClass {
	return [RAFTableSectionMoment class];
}

+ (BOOL)sectionsMirrorData {
	return YES;
}

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		_tableView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.f];

		Class TableFormMomentClass = self.class.tableFormMomentClass;
		Class TableSectionMomentClass = self.class.tableSectionMomentClass;

		if (self.class.sectionsMirrorData) {
			self.sections = self.allValues;
		}

		RAC(self.tableController) = [[[[RACAbleWithStart(self.sections) map:^id(NSArray *sections) {
			return [RACSignal combineLatest:[sections.rac_sequence map:^id(RAFTableSection *section) {
				NSArray *components = @[ RACAbleWithStart(section, rows), RACAbleWithStart(section, headerTitle), RACAbleWithStart(section, footerTitle), RACAbleWithStart(section, headerView), RACAbleWithStart(section, footerView) ];
				return [RACSignal combineLatest:components reduce:^(NSArray *rows, NSString *header, NSString *footer, UIView *headerView, UIView *footerView) {
					return [[TableSectionMomentClass alloc] initWithRows:rows headerTitle:header footerTitle:footer headerView:headerView footerView:footerView];
				}];
			}]];
		}].switchToLatest map:^(RACTuple *sections) {
			return [[TableFormMomentClass alloc] initWithSectionMoments:sections.rac_sequence.array];
		}] deliverOn:RACScheduler.mainThreadScheduler] startWith:[RAFTableFormMoment new]];

		RACSignal *editingDestinations = [RACAbleWithStart(self.rowsByEditingOrder) map:^(NSArray *rows) {
			if (!rows) return [RACSignal empty];

			return [RACSignal merge:[rows.rac_sequence map:^(RAFTableRow *row) {
				return [row.fieldDidFinishEditingSignal map:^(RACUnit *unit) {
					NSUInteger currentIndex = [rows indexOfObject:row];
					NSUInteger nextIndex = currentIndex + 1;
					return rows.count > nextIndex ? rows[nextIndex] : nil;
				}];
			}]];
		}].switchToLatest;

		[RACAbleWithStart(self.rowsByEditingOrder) subscribeNext:^(NSArray *rows) {
			[rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger idx, BOOL *stop) {
				row.lastInTabOrder = idx == rows.count - 1;
			}];
		}];

		[editingDestinations subscribeNext:^(RAFTableRow *row) {
			[row beginEditing];
		}];

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
		NSArray *oldSections = oldController.sectionMoments;
		NSArray *newSections = controller.sectionMoments;

		NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet indexSet];
		NSMutableIndexSet *sectionsToInsert = [NSMutableIndexSet indexSet];
		NSMutableArray *rowsToInsert = [NSMutableArray array];
		NSMutableArray *rowsToDelete = [NSMutableArray array];
		NSMutableArray *rowsToMove = [NSMutableArray array];

		[oldSections enumerateObjectsUsingBlock:^(RAFTableSectionMoment *section, NSUInteger sectionIndex, BOOL *stop) {
			if (controller.sectionMoments.count <= sectionIndex) {
				[sectionsToDelete addIndex:sectionIndex];
			}

			[section.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				if (![controller indexPathForRow:row]) {
					[rowsToDelete addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
				}
			}];
		}];

		[newSections enumerateObjectsUsingBlock:^(RAFTableSectionMoment *section, NSUInteger sectionIndex, BOOL *stop) {
			if (oldController.sectionMoments.count <= sectionIndex) {
				[sectionsToInsert addIndex:sectionIndex];
			}

			[section.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
				NSIndexPath *oldIndexPath = [oldController indexPathForRow:row];

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

@implementation RAFCustomTableForm

+ (BOOL)sectionsMirrorData {
	return NO;
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
