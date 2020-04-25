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

    def parent=(pnode) #(1) sets the parent property and (2) adds the node to their parent's array of children (unless we're setting parent to nil).
        @parent = pnode
        unless @parent.nil? 
            unless pnode.children.include?(self)
                pnode.children << self
            end
        end
    end

end