//
//  RAFFormlet.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveFormlets.h"
#import "RAFReifiedProtocol.h"
#import "RAFModel.h"

/// A formlet emits a signal and provides a channel terminal through which values
/// are passed in and out. A formlet may either bind directly to an interface, or
/// may be composed of other formlets.
@protocol RAFFormlet

/// Formlets have a channel, which should not be used externally.
@property (strong, readonly, nonatomic) RACChannel *channel;

/// Returns the terminal to which you may send values to manually update
/// the form, or subscribe to listen to user-initiated updates.
- (RACChannelTerminal *)channelTerminal;

/// Returns a signal of RAFValidation objects, with validation failures for all
/// subordinate form elements accumulated.
@property (strong, readonly, nonatomic) RACSignal *validationSignal;

/// Returns a signal of unvalidated values.
@property (strong, readonly, nonatomic) RACSignal *totalDataSignal;

/// Whether the formlet is editable or now. Should default to YES.
@property (assign, nonatomic, getter = isEditable) BOOL editable;
@end

@class RAFValidator;

/// A primitive formlet is one which binds directly to an interface.
/// `RAFPrimitiveFormlet` subclasses must provide their own `-buildChannel`
/// implementations.
@interface RAFPrimitiveFormlet : NSObject <RAFFormlet>

/// Primitive formlets have a validator through which values are passed.
@property (strong, readonly, nonatomic) RAFValidator *validator;

/// Initialize with a non-nil validator.
- (id)initWithValidator:(RAFValidator *)validator;

/// Constructs the channel which will be cached under the `channel` property.
/// Subclasses must implement this method; it will only be called once per
/// formlet.
- (RACChannel *)buildChannel;

/// A bidirectional value transformer; by default, the Identity transformer is
/// used if none is provided.
- (NSValueTransformer *)valueTransformer;
@end

/// A compound formlet is one which is composed of smaller formlets, as specified
/// in the model protocol it is initialized from.
@interface RAFCompoundFormlet : RAFReifiedProtocol <RAFFormlet>
@end

/// A compound formlet is an ordered dictionary, where its keys are model fields
/// and its values are other formlets. We can refine the dictionary accessors
/// to indicate that all elements of a compound formlet are other formlets.
@interface RAFCompoundFormlet (Safety)
- (id<RAFFormlet>)objectForKey:(id<NSCopying>)key;
- (id<RAFFormlet>)objectForKeyedSubscript:(id<NSCopying>)key;
- (id)copy DEPRECATED_ATTRIBUTE;
- (id)copyWithZone:(NSZone *)zone DEPRECATED_ATTRIBUTE;
- (id)mutableCopy DEPRECATED_ATTRIBUTE;
@end

@interface RAFPrimitiveFormlet (Safety)
- (id)copy DEPRECATED_ATTRIBUTE;
- (id)copyWithZone:(NSZone *)zone DEPRECATED_ATTRIBUTE;
- (id)mutableCopy DEPRECATED_ATTRIBUTE;
@end
