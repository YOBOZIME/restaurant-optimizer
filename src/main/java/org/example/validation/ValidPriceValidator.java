package org.example.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class ValidPriceValidator implements ConstraintValidator<ValidPrice, Double> {

    private double min = 0;
    private double max = 10000;

    @Override
    public void initialize(ValidPrice constraintAnnotation) {
        // Can customize min/max from annotation attributes if needed
    }

    @Override
    public boolean isValid(Double value, ConstraintValidatorContext context) {
        if (value == null) {
            // Use @NotNull for null checking, this handles price validation
            return true; // Allow null, let @NotNull handle it
        }
        return value >= min && value <= max;
    }
}