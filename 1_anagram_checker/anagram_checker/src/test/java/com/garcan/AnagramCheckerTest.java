package com.garcan;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AnagramCheckerTest {

    @Test
    void testAreAnagrams() {
        // Provided test case
        assertTrue(AnagramChecker.areAnagrams("Tom Marvolo Riddle", "I am Lord Voldemort"));

        // Other cases
        assertTrue(AnagramChecker.areAnagrams("heart", "earth"));
        assertTrue(AnagramChecker.areAnagrams("cars", "scar"));
        assertTrue(AnagramChecker.areAnagrams("star", "rats"));
        assertTrue(AnagramChecker.areAnagrams("listen", "silent"));
        assertTrue(AnagramChecker.areAnagrams("abcd", "dcba"));
        assertTrue(AnagramChecker.areAnagrams("!@#$%", "%$#@!"));

        assertFalse(AnagramChecker.areAnagrams("python", "java"));
    }

    @Test
    void testEmptyStrings() {
        assertTrue(AnagramChecker.areAnagrams("   ", ""));
        assertFalse(AnagramChecker.areAnagrams("", "notempty"));
    }

    @Test
    void testWhitespaces() {
        assertTrue(AnagramChecker.areAnagrams("hello world", "world hello"));
        assertTrue(AnagramChecker.areAnagrams("  spaces  ", "spaces"));
    }

    @Test
    void testDifferentCases() {
        assertTrue(AnagramChecker.areAnagrams("Tom Marvolo Riddle", "I AM LORD VOLDEMORT"));
        assertTrue(AnagramChecker.areAnagrams("Python", "nOhtyP"));
    }

    @Test
    void testNumbers() {
        assertTrue(AnagramChecker.areAnagrams("abc123", "123abc"));
        assertTrue(AnagramChecker.areAnagrams("1+3+4+2=10", "(1*3*4)-2=10"));
    }

    @Test
    void testNonAscii() {
        assertTrue(AnagramChecker.areAnagrams("café", "éfac"));
        assertTrue(AnagramChecker.areAnagrams("resumé", "emusér"));
    }

    @Test
    void testDifferentLenghts() {
        assertFalse(AnagramChecker.areAnagrams("abcd", "abc"));
        assertFalse(AnagramChecker.areAnagrams("abc", "abcd"));
    }

    @Test
    void testAnagramPhrases() {
        assertTrue(AnagramChecker.areAnagrams("Vacation time", "I am not active"));
        assertTrue(AnagramChecker.areAnagrams("Eleven plus two", "twelve plus one"));
        assertTrue(AnagramChecker.areAnagrams("A rolling stone gathers no moss", "stroller go on amasses nothing"));
        assertTrue(AnagramChecker.areAnagrams("A decimal point", "I'm a dot in place"));
        assertTrue(AnagramChecker.areAnagrams("Payment received", "every cent paid me"));
        assertTrue(AnagramChecker.areAnagrams("William Shakespeare", "I'll make a wise phrase"));
        assertTrue(AnagramChecker.areAnagrams("Adolf Hitler", "Do real filth"));
        assertTrue(AnagramChecker.areAnagrams("Tom Cruise", "So I'm cuter"));
        assertTrue(AnagramChecker.areAnagrams("Clint Eastwood", "old west action"));
        assertTrue(AnagramChecker.areAnagrams("Elvis Presley", "Presley lives"));
    }

    @Test
    void testNonAnagramPhrases() {
        assertFalse(AnagramChecker.areAnagrams("Vacation time", "I am active"));
        assertFalse(AnagramChecker.areAnagrams("Eleven plus two", "twelve plus ones"));
        assertFalse(AnagramChecker.areAnagrams("Payment received", "every cent pays me"));
        assertFalse(AnagramChecker.areAnagrams("Elvis Presley", "Does Presley live?"));
    }
}
