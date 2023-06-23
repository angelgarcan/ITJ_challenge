package com.garcan;

import java.util.Arrays;

public class AnagramChecker {

    private AnagramChecker(){}

    public static boolean areAnagrams(final String str1, final String str2) {
        final char[] sanitizedArr1 = str1.replaceAll("[\\p{Punct}\\s]", "").toLowerCase().toCharArray();
        final char[] sanitizedArr2 = str2.replaceAll("[\\p{Punct}\\s]", "").toLowerCase().toCharArray();

        Arrays.sort(sanitizedArr1);
        Arrays.sort(sanitizedArr2);

        // #FIXME: ONLY4DEBUG
        // System.out.println(str1 + " -> " + Arrays.toString(sanitizedArr1));
        // System.out.println(str2 + " -> " + Arrays.toString(sanitizedArr2));

        return Arrays.equals(sanitizedArr1, sanitizedArr2);
    }
}
