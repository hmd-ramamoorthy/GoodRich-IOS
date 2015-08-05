//
//  ILSaturationBrightnessPicker.h
//
//  Created by Jon Gilkison on 9/1/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILView.h"
#import "ILHuePickerView.h"

@class ILSaturationBrightnessPickerView;

/**
 * Delegate for ILSaturationBrightnessPicker
 */
@protocol ILSaturationBrightnessPickerViewDelegate

/**
 * Called when the color changes.
 *
 * @param newColor The new color
 * @param picker The picker whose color changed
 */
-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker;

@end

/**
 * View for picking the color's saturation and brightness
 */
@interface ILSaturationBrightnessPickerView : ILView<ILHuePickerViewDelegate> {
    __weak id<ILSaturationBrightnessPickerViewDelegate> delegate;
    
    float hue;
    float saturation;
    float brightness;
}

/**
 * Delegate
 */
@property (weak, nonatomic) IBOutlet id<ILSaturationBrightnessPickerViewDelegate> delegate;

/**
 * Get/Set the current hue
 */
@property (assign, nonatomic) float hue;

/**
 * Get/Set the current saturation
 */
@property (nonatomic) float saturation;

/**
 * Get/Set the current brightness
 */
@property (nonatomic) float brightness;

/**
 * The current color
 */
@property (weak, nonatomic) UIColor *color;


@end
