//
//  Settings+CoreDataProperties.h
//  Four in Line
//
//  Created by Vasilii Muravev on 11.09.16.
//  Copyright © 2016 Vasilii Muravev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface Settings (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *difficult;
@property (nullable, nonatomic, retain) NSNumber *firstMoveHuman;
@property (nullable, nonatomic, retain) NSNumber *numOfColumns;
@property (nullable, nonatomic, retain) NSNumber *numOfLines;

@end

NS_ASSUME_NONNULL_END
