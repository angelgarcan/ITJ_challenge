package com.garcan;

import java.util.Arrays;

public class AnagramChecker {

    private static final String RGX_PUNT_WSPACE = "[\\p{Punct}\\s]"; // Matches punctuation or whitespace character.

    private AnagramChecker() {
    }

    public static boolean areAnagrams(final String str1, final String str2) {
        final char[] sanitizedArr1 = str1.replaceAll(RGX_PUNT_WSPACE, "").toLowerCase().toCharArray();
        final char[] sanitizedArr2 = str2.replaceAll(RGX_PUNT_WSPACE, "").toLowerCase().toCharArray();

        Arrays.sort(sanitizedArr1);
        Arrays.sort(sanitizedArr2);

        // #FIXME: ONLY4DEBUG
        // System.out.println("[" + str1 + "] <-> [" + str2 + "]: "
        // + Arrays.equals(sanitizedArr1, sanitizedArr2)
        // + "\n " + Arrays.toString(sanitizedArr1)
        // + "\n " + Arrays.toString(sanitizedArr2));

        // If both sanitized and sorted char arrays ara equal returns true.
        return Arrays.equals(sanitizedArr1, sanitizedArr2);
    }
}
