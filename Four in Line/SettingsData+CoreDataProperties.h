//
//  SettingsData+CoreDataProperties.h
//  Four in Line
//
//  Created by Vasilii Muravev on 11.09.16.
//  Copyright © 2016 Vasilii Muravev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SettingsData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsData (CoreDataProperties)

@property (nonatomic) int16_t difficult;
@property (nonatomic) BOOL firstMoveHuman;
@property (nonatomic) int16_t numOfColumns;
@property (nonatomic) int16_t numOfLines;

@end

NS_ASSUME_NONNULL_END
