package org.example.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = ValidPriceValidator.class)
public @interface ValidPrice {
    String message() default "Invalid price value";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}