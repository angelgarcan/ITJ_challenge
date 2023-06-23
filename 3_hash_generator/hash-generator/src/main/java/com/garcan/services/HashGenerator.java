package com.garcan.services;

import java.security.MessageDigest;
import java.util.regex.Pattern;

public class HashGenerator {

    private static final Pattern PATTERN_NUMBER = Pattern.compile(".*\\d+.*");
    private static final Pattern PATTERN_SPECIAL_CHAR = Pattern
            .compile(".*[!@#$%^&*()\\-_+=\\\\|\\[\\]{};':\",./<>?]+.*");

    private HashGenerator(){}

    public static String generateSHA256Hash(String input) throws Exception {
        if (!isValidInput(input)) {
            throw new Exception(
                    "Invalid input. The string must consist of at least 8 characters, at least one number, and at least one special character");
        }

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedHash = digest.digest(input.getBytes());

        // Convert the byte array into hexadecimal string
        StringBuilder hexString = new StringBuilder();
        for (byte b : encodedHash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1)
                hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public static boolean isValidInput(String input) {
        return input.length() >= 8 &&
                PATTERN_NUMBER.matcher(input).matches() &&
                PATTERN_SPECIAL_CHAR.matcher(input).matches();
    }
}
