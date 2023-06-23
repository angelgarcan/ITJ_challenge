package com.garcan;

import java.util.Stack;
import java.util.function.Predicate;
import java.util.stream.Stream;

public class BalancedParenthesis {
    private enum CharPair {
        PARENTHESES('(', ')'),
        BRACKETS('[', ']'),
        BRACES('{', '}');

        private final char opening;
        private final char closing;

        private CharPair(char opening, char closing) {
            this.opening = opening;
            this.closing = closing;
        }

        private static Character findOpening(char closing) {
            for (CharPair pair : CharPair.values()) {
                if (pair.closing == closing) {
                    return pair.opening;
                }
            }
            return null;
        }
    }

    private static final Predicate<Character> isOpeningChar = c -> Stream.of(CharPair.values())
            .anyMatch(pair -> pair.opening == c);
    private static final Predicate<Character> isClosingChar = c -> Stream.of(CharPair.values())
            .anyMatch(pair -> pair.closing == c);

    public static boolean isBalanced(String input) {
        if (input.length() % 2 != 0) {
            return false; // Odd input cannot be balanced
        }

        Stack<Character> stack = new Stack<>();
        for (char c : input.toCharArray()) {
            if (isOpeningChar.test(c)) {
                stack.push(c);
            } else if (isClosingChar.test(c)) {
                if (stack.isEmpty()) {
                    return false; // Closing parenthesis with no matching opening parenthesis
                }
                Character opening = CharPair.findOpening(c);
                if (opening == null) {
                    return false; // Isnt a closing char
                }
                char top = stack.pop();
                if (opening != top) {
                    return false; // Mismatched closing parenthesis
                }
            }
        }
        return stack.isEmpty(); // True if all opening parentheses have matching
    }
}
