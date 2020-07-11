#my_min
#Given a list of integers find the smallest number in the list.
list = [ 0, 3, 5, 4, -5, 10, 1, 90 ]

# Phase I
# First, write a function that compares each element to every other element of the list. Return the element if all other elements in the array are larger.
# What is the time complexity for this function?
##Time complexity is quadratic - 0(N^2)

def my_min1(array)

    array.each_with_index do |ele1, i1|
        small_ele = true
        array.each_with_index do |ele2, i2|
            next if i2 == i1
           small_ele = false if ele2 <  ele1
        end
    return ele1 if small_ele
    end
end

#Phase II
# Now rewrite the function to iterate through the list just once while keeping track of the minimum. What is the time complexity?

def my_min2(list)
    min = list.first
    list.each do |ele|
        if ele < min
            min = ele
        end
    end
    min
end


# p my_min1(list)
# p my_min2(list)

# Largest Contiguous Sub-sum
# You have an array of integers and you want to find the largest contiguous (together in sequence) sub-sum. Find the sums of all contiguous sub-arrays and return the max.

# Phase I
# Write a function that iterates through the array and finds all sub-arrays using nested loops. First make an array to hold all sub-arrays. Then find the sums of each sub-array and return the max.

# Discuss the time complexity of this solution.

def contiguous_sum1(list)
    sub_arrays = []
    list.each_index do |idx1|
        (idx1...list.length).each do |idx2|
            sub_arrays << list[idx1..idx2]
        end
    end

    max_sum = sub_arrays.first.sum
    sub_arrays.each do |sub_array|
        if sub_array.sum > max_sum
            max_sum = sub_array.sum
        end
    end
    max_sum

end

# Phase II
# Let's make a better version. Write a new function using O(n) time with O(1) memory. Keep a running tally of the largest sum. To accomplish this efficient space complexity, consider using two variables. One variable should track the largest sum so far and another to track the current sum. We'll leave the rest to you.

def contiguous_sum2(list)
    largest = list.first
    current = list.first

    (1...list.length).each do |i|
        current = 0 if current < 0
        current += list[i]
        largest = current if current > largest
    end
    largest

end



list = [5, 3, -7] #8
list2 = [2, 3, -6, 7, -6, 7] #8
list3 = [-5, -1, -3] #-1

p contiguous_sum1(list)
p contiguous_sum1(list2)
p contiguous_sum1(list3)
p contiguous_sum2(list)
p contiguous_sum2(list2)
p contiguous_sum2(list3)