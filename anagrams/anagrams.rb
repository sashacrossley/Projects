#Anagrams
# Our goal today is to write a method that determines if two given words are anagrams. This means that the letters in one word can be rearranged to form the other word. For example:

# anagram?("gizmo", "sally")    #=> false
# anagram?("elvis", "lives")    #=> true
# Assume that there is no whitespace or punctuation in the given strings

# Phase I:
# Write a method #first_anagram? that will generate and store all the possible anagrams of the first string. Check if the second string is one of these.

# Hints:

# For testing your method, start with small input strings, otherwise you might wait a while
# If you're having trouble generating the possible anagrams, look into this method.
# What is the time complexity of this solution? What happens if you increase the size of the strings?

def first_anagram?(word1, word2)
    get_anagram(word1).include?(word2)
end

def get_anagram(word)
    new_anagrams = []
    return [word] if word.length <=1
    prev_anagrams = get_anagram(word[0...-1])
    prev_anagrams.each do |anagram|
        (0..anagram.length).each do |i|
            new_anagrams << anagram.dup.insert(i, word[-1])
        end
    end
    new_anagrams

end


# p first_anagram?("gizmo", "sally")
# p first_anagram?("elvis", "lives")

# Phase II:
# Write a method #second_anagram? that iterates over the first string. For each letter in the first string, find the index of that letter in the second string (hint: use Array#find_index) and delete at that index. The two strings are anagrams if an index is found for every letter and the second string is empty at the end of the iteration.

# Try varying the length of the input strings. What are the differences between #first_anagram? and #second_anagram??

def second_anagram?(word1, word2)
    word2array = word2.split("")
    word1.each_char do |letter|
        idx = word2array.index(letter)
        if idx.nil?
            return false
        else
            word2array.delete_at(idx)
        end
    end

    word2array.empty?
end

# p second_anagram?("gizmo", "sally")
# p second_anagram?("elvis", "lives")

# Phase III:
# Write a method #third_anagram? that solves the problem by sorting both strings alphabetically. The strings are then anagrams if and only if the sorted versions are the identical.

# What is the time complexity of this solution? Is it better or worse than #second_anagram??

def third_anagram?(word1, word2)
    word1a = word1.split("").sort
    word2a = word2.split("").sort

    word1a == word2a
end

# p third_anagram?("gizmo", "sally")
# p third_anagram?("elvis", "lives")

# Phase IV:
# Write one more method #fourth_anagram?. This time, use two Hashes to store the number of times each letter appears in both words. Compare the resulting hashes.

# What is the time complexity?

# O(n) linear time
# O(1) constant space
def fourth_anagram?(word1, word2)
    count1 = Hash.new(0)
    count2 = Hash.new(0)

    word1.each_char {|char| count1[char]+=1}
    word2.each_char {|char| count2[char]+=1}

    count1 == count2

end

# p fourth_anagram?("gizmo", "sally")
# p fourth_anagram?("elvis", "lives")

# Bonus: Do it with only one hash.

def fifth_anagram?(word1, word2)
    counter = Hash.new(0)
    (word1+word2).each_char {|char|counter[char] += 1}

    counter.each_value.all? {|count| count.even?}
end

# p fifth_anagram?("gizmo", "sally")
# p fifth_anagram?("elvis", "lives")