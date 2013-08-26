//
//RAFTableForm.m
//ReactiveFormlets
//
//Created by Jon Sterling on 6/12/12.
//Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableForm.h"
#import "RAFTableSection.h"
#import "RAFTableRow.h"
#import "RAFObjCRuntime.h"
#import "EXTScope.h"
#import "RAFTableFormMoment.h"
#import "RAFTableSection.h"

@interface RAFTableForm ()
@property (strong) RAFTableFormMoment *tableController;
@end

@implementation RAFTableForm

+ (Class)tableFormMomentClass {
	return [RAFTableFormMoment class];
}

+ (Class)tableSectionMomentClass {
	return [RAFTableSection class];
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

		if (self.class.sectionsMirrorData) {
			self.sections = self.allValues;
		}

		RAC(self.tableController) = [[[[RACAbleWithStart(self.sections) map:^id(NSArray *sections) {
			return [RACSignal combineLatest:[sections.rac_sequence map:^(RAFTableSection *section) {
				return section.moments;
			}]];
		}].switchToLatest map:^(RACTuple *sections) {
			return [[TableFormMomentClass alloc] initWithSectionMoments:sections.rac_sequence.array];
		}] deliverOn:RACScheduler.mainThreadScheduler] startWith:[RAFTableFormMoment new]];

		RACSignal *includedRows = [RACAbleWithStart(self.sections) map:^(NSArray *sections) {
			return [sections.rac_sequence flattenMap:^RACStream *(RAFTableSection *section) {
				return section.rows.rac_sequence;
			}].array;
		}];

		RACSignal *includedRowsByEditingOrder = [RACSignal combineLatest:@[ RACAbleWithStart(self.rowsByEditingOrder), includedRows ] reduce:^(NSArray *rows, NSArray *includedRows) {
			if (!rows) {
				return [includedRows.rac_sequence filter:^BOOL(RAFTableRow *row) {
					return [row canEdit];
				}].array;
			}

			return [rows.rac_sequence filter:^BOOL(RAFTableRow *row) {
				return [includedRows containsObject:row];
			}].array;
		}];

		RACSignal *editingDestinations = [includedRows map:^(NSArray *rows) {
			if (!rows) return [RACSignal empty];

			return [RACSignal merge:[rows.rac_sequence map:^(RAFTableRow *row) {
				return [row.fieldDidFinishEditingSignal map:^(RACUnit *unit) {
					NSUInteger currentIndex = [rows indexOfObject:row];
					NSUInteger nextIndex = currentIndex + 1;
					return rows.count > nextIndex ? rows[nextIndex] : nil;
				}];
			}]];
		}].switchToLatest;

		[includedRowsByEditingOrder subscribeNext:^(NSArray *rows) {
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
//			RACTupleUnpack(RAFTableFormMoment *controller, NSIndexSet *sectionsToDelete, NSIndexSet *sectionsToInsert, NSArray *rowsToDelete, NSArray *rowsToInsert, NSArray *rowsToMove) = tuple;
//
//			[self.tableView beginUpdates];
//
//			[self.tableView deleteSections:sectionsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
//			[self.tableView insertSections:sectionsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
//			[self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
//			[self.tableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
//
//			for (RACTuple *move in rowsToMove) {
//				[self.tableView moveRowAtIndexPath:move.first toIndexPath:move.second];
//			}

			self.tableView.dataSource = tuple.first;
			self.tableView.delegate = tuple.first;
			[self.tableView reloadData];
			
//			[self.tableView endUpdates];
		}];
	}

	return self;
}

- (RACSignal *)tableViewUpdatesSignal {
	return [RACAble(self.tableController) mapPreviousWithStart:[RAFTableFormMoment new] combine:^id(RAFTableFormMoment *oldController, RAFTableFormMoment *newController) {
		NSArray *oldSections = oldController.sectionMoments ?: @[];
		NSArray *newSections = newController.sectionMoments;

		NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet indexSet];
		NSMutableIndexSet *sectionsToInsert = [NSMutableIndexSet indexSet];
		NSMutableArray *rowsToInsert = [NSMutableArray array];
		NSMutableArray *rowsToDelete = [NSMutableArray array];
		NSMutableArray *rowsToMove = [NSMutableArray array];

		[oldSections enumerateObjectsUsingBlock:^(RAFTableSection *oldSection, NSUInteger sectionIndex, BOOL *stop) {
			BOOL sectionIsDeleted = ![newController.sectionMoments containsObject:oldSections];
			if (sectionIsDeleted) [sectionsToDelete addIndex:sectionIndex];

			[oldSection.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				if (![newController indexPathForRow:row]) {
					[rowsToDelete addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
				}
			}];
		}];

		[newSections enumerateObjectsUsingBlock:^(RAFTableSection *newSection, NSUInteger sectionIndex, BOOL *stop) {
			BOOL sectionIsInserted = ![oldController.sectionMoments containsObject:newSection];
			if (sectionIsInserted) [sectionsToInsert addIndex:sectionIndex];

			[newSection.rows enumerateObjectsUsingBlock:^(RAFTableRow *row, NSUInteger rowIndex, BOOL *stop) {
				NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
				NSIndexPath *oldIndexPath = [oldController indexPathForRow:row];

				if (oldIndexPath) {
					[rowsToMove addObject:RACTuplePack(oldIndexPath, newIndexPath)];
				} else {
					[rowsToInsert addObject:newIndexPath];
				}
			}];
		}];

		return RACTuplePack(newController, [sectionsToDelete copy], [sectionsToInsert copy], [rowsToDelete copy], [rowsToInsert copy], [rowsToMove copy]);
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
