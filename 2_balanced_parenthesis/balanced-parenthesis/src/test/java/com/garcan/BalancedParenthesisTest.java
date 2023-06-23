package com.garcan;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class BalancedParenthesisTest {

    @Test
    void testBalancedParenthesis() {
        assertTrue(BalancedParenthesis.isBalanced("((({{{[[[]]]}}})))"));
        assertTrue(BalancedParenthesis.isBalanced("{{{[][][]}}}"));
        assertTrue(BalancedParenthesis.isBalanced("()(){{{}}}[][]"));
        assertTrue(BalancedParenthesis.isBalanced("()()()()"));
    }
    
    @Test
    void testEmptyString() {
        assertTrue(BalancedParenthesis.isBalanced(""));
    }
    
    @Test
    void testOddLengthString() {
        assertFalse(BalancedParenthesis.isBalanced("("));
        assertFalse(BalancedParenthesis.isBalanced("{{"));
        assertFalse(BalancedParenthesis.isBalanced("]"));
    }
    
    @Test
    void testUnbalancedParenthesis() {
        assertFalse(BalancedParenthesis.isBalanced("(((())})"));
        assertFalse(BalancedParenthesis.isBalanced(")((()))()()"));
        assertFalse(BalancedParenthesis.isBalanced("((()()()))(()"));
        assertFalse(BalancedParenthesis.isBalanced("()()("));
        assertFalse(BalancedParenthesis.isBalanced("}}{"));
    }
}
