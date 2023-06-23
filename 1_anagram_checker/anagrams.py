import unittest
import string

def are_anagrams(str1, str2):
    sorted_str1=sorted("".join(ch for ch in str1 if ch not in string.punctuation + string.whitespace).lower())
    sorted_str2=sorted("".join(ch for ch in str2 if ch not in string.punctuation + string.whitespace).lower())
    
    #print(str1,"->",sorted_str1)
    #print(str2,"->",sorted_str2)
    
    return sorted_str1 == sorted_str2

class TestAnagram(unittest.TestCase):
    def test_are_anagrams(self):
        # Provided test case
        self.assertTrue(are_anagrams("Tom Marvolo Riddle", "I am Lord Voldemort"))
        
        self.assertTrue(are_anagrams("heart", "earth"))
        self.assertTrue(are_anagrams("cars", "scar"))
        self.assertTrue(are_anagrams("star", "rats"))
        self.assertTrue(are_anagrams("listen", "silent"))
        self.assertTrue(are_anagrams("abcd", "dcba"))
        self.assertTrue(are_anagrams("!@#$%", "%$#@!"))
        
        self.assertFalse(are_anagrams("python", "java"))

        # Test cases with empty strings
        self.assertTrue(are_anagrams("   ", ""))
        self.assertFalse(are_anagrams("", "notempty"))

        # Test cases with whitespace
        self.assertTrue(are_anagrams("hello world", "world hello"))
        self.assertTrue(are_anagrams("  spaces  ", "spaces"))

        # Test cases with different letter cases
        self.assertTrue(are_anagrams("Tom Marvolo Riddle", "I AM LORD VOLDEMORT"))
        self.assertTrue(are_anagrams("Python", "nOhtyP"))

        # Test cases with numbers
        self.assertTrue(are_anagrams("abc123", "123abc"))
        self.assertTrue(are_anagrams("1+3+4+2=10", "(1*3*4)-2=10"))

        # Test cases with non-ASCII characters
        self.assertTrue(are_anagrams("café", "éfac"))
        self.assertTrue(are_anagrams("resumé", "emusér"))

        # Test cases with different lengths
        self.assertFalse(are_anagrams("abcd", "abc"))
        self.assertFalse(are_anagrams("abc", "abcd"))
        
        # Anagram phrases
        self.assertTrue(are_anagrams("Vacation time", "I am not active"))
        self.assertTrue(are_anagrams("Eleven plus two", "twelve plus one"))
        self.assertTrue(are_anagrams("A rolling stone gathers no moss", "stroller go on amasses nothing"))
        self.assertTrue(are_anagrams("A decimal point", "I'm a dot in place"))
        self.assertTrue(are_anagrams("Payment received", "every cent paid me"))
        self.assertTrue(are_anagrams("William Shakespeare", "I'll make a wise phrase"))
        self.assertTrue(are_anagrams("Adolf Hitler", "Do real filth"))
        self.assertTrue(are_anagrams("Tom Cruise", "So I'm cuter"))
        self.assertTrue(are_anagrams("Clint Eastwood", "old west action"))
        self.assertTrue(are_anagrams("Elvis Presley", "Presley lives"))

        # Non-anagram phrases
        self.assertFalse(are_anagrams("Vacation time", "I am active"))
        self.assertFalse(are_anagrams("Eleven plus two", "twelve plus ones"))
        self.assertFalse(are_anagrams("Payment received", "every cent pays me"))
        self.assertFalse(are_anagrams("Elvis Presley", "Does Presley live?"))


if __name__ == "__main__":
    unittest.main()


