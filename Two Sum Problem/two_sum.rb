#Let's start by implementing the brute force solution. Write a method called bad_two_sum?, which checks every possible pair.
#Quadratic time complexity
def bad_two_sum?(arr, target_sum)
    arr.each_with_index do |ele1, idx1|
        arr.each_with_index do |ele2, idx2|
            next if idx1 == idx2
            sum = ele1 + ele2
            return true if sum == target_sum
        end
    end
false  
end

arr = [0, 1, 5, 7]
p bad_two_sum?(arr, 6) # => should be true
p bad_two_sum?(arr, 10) # => should be false

#As a person of elevated algorithmic sensibilities, the brute-force approach is beneath you. Leave that nonsense to the riffraff. Instead, you'll apply a refined and time-honored technique: sorting.

# Sort your data, then try to solve the problem.

# What does sorting do to the lower bound of your time complexity?
# How might sorting that make the problem easier?
# Write a second solution, called okay_two_sum?, which uses sorting. Make sure it works correctly.

# Hint: (There are a couple ways to solve this problem once it's sorted. One way involves using a very cheap algorithm that can only be used on sorted data sets. What are some such algorithms you know?)

def okay_two_sum?(arr, target_sum)
    arr = arr.sort
    idx1 = 0
    idx2 = (arr.length) - 1

    while idx1 <  idx2
        sum = arr[idx1] + arr[idx2]
        if sum == target_sum
            return true
        elsif sum < target_sum
            idx1 += 1
        elsif sum > target_sum
            idx2 -= 1
        end
    end
    false
end

arr = [0, 1, 5, 7]
p okay_two_sum?(arr, 6) # => should be true
p okay_two_sum?(arr, 10) # => should be false

# Hash Map
# Finally, it's time to bust out the big guns: a hash map. Remember, a hash map has O(1) #set and O(1) #get, so you can build a hash out of each of the n elements in your array in O(n) time. That hash map prevents you from having to repeatedly find values in the array; now you can just look them up instantly.

# See if you can solve the two_sum? problem in linear time now, using your hash map.

def two_sum?(arr, target_sum)
    answer = {}
    arr.each do |ele|
        return true if answer[target_sum-ele] #if the difference between the sum and the current element equals a previously identified element then you return true
        answer[ele] = true
    end
    false
end


arr = [0, 1, 5, 7]
p two_sum?(arr, 6) # => should be true
p two_sum?(arr, 10) # => should be false