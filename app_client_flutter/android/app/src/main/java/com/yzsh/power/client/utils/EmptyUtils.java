package com.yzsh.power.client.utils;

import androidx.annotation.Nullable;

import java.util.Collection;
import java.util.Map;

public final class EmptyUtils {
    private EmptyUtils() {}
    public static boolean isEmpty(Object reference) {
        return reference == null;
    }
    public static boolean isEmpty(Map reference) {
        return reference == null || reference.isEmpty();
    }
    public static boolean isEmpty(Collection reference) {
        return reference == null || reference.size() == 0;
    }
    public static boolean isEmpty(String reference) {
        return reference == null || "".equals(reference);
    }
    public static <T> T checkNotNull(T reference) {
        if (reference == null) {
            throw new NullPointerException();
        } else {
            return reference;
        }
    }
    public static <T> T checkNotNull(T reference, @Nullable Object errorMessage) {
        if (reference == null) {
            throw new NullPointerException(String.valueOf(errorMessage));
        } else {
            return reference;
        }
    }
}