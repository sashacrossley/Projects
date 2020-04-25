class PolyTreeNode
    
    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def parent #returns the node's parent
        @parent
    end

    def children #returns an array of children of a node
        @children
    end

    def value #returns the value stored at the node
        @value
    end

    def parent=(pnode) #(1) sets the parent property and (2) adds the node to their parent's array of children (unless we're setting parent to nil). we should also remove the child from the old parent's list of children (if the old parent isn't nil). Modify your #parent= method to do this.
        unless @parent.nil?
            @parent.children.delete_if {|child| child == self}
        end
        @parent = pnode
        unless @parent.nil? 
            unless pnode.children.include?(self)
                pnode.children << self
            end
        end
    end

    def add_child(child_node)
        child_node.parent=self
    end

    def remove_child(child_node)
        raise "not a child" if !children.include?(child_node)
        child_node.parent=nil
    end

    def dfs(target_value)
        return self if value == target_value
        children.each do |child|
            search = child.dfs(target_value)
            return search unless search.nil?
        end
        nil
    end

    def bfs(target_value)
        queue = [self]
        until queue.empty?
            ele = queue.shift
            return ele if ele.value == target_value
            ele.children.each {|child| queue << child}
        end
    end

end