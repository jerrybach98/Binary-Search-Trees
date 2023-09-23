class Tree
  attr_accessor :root

  def initialize(array)
    p array = array.sort.uniq
    @root = build_tree(array)
  end

  def build_tree(array)
    if array.length == 0
      return nil
    end

    middle = array.length / 2
    root = Node.new(array[middle])
    root.left = build_tree(array[0...middle])
    root.right = build_tree(array[middle + 1..-1])
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end


# insert and delete method
# will insert as a leaf
# compare value to roots then choose order to add less/left, otherwise right
# insert if nil (leaf)
# don't add if duplicate?
  def insert(node = @root, value) 
    if node == nil
      return node = Node.new(value)
    end

    if value < node.data 
      node.left = insert(node.left, value)
    elsif value > node.data 
      node.right = insert(node.right, value)
    end

    return node
  end

  # 1st case, delete leaf easily, set it equal to nil
  # 2nd case, replace node with child
  # 3rd case, two children, find thing that is next biggest in array. Look far left in right subtree to replace,
    # if the furthest left has children, it is smallest in subtree, every child will only have right subtrees
  def delete(node = @root, value)
    # Base for recursion
    if node == nil
      return node
    end

    # recursion for traversal
    if value < node.data
      node.left = delete(node.left, value)
      return node
    elsif value > node.data
      node.right = delete(node.right, value)
      return node
    end

    # Deletion logic
    # one or no child
    if node.left == nil
      return node.right
    elsif node.right == nil
      return node.left
    # two children
    else
      succ_parent = node
      successor = node.right
      #find successor
      until successor.left == nil
        succ_parent = successor
        successor = successor.left
      end

      # is parent of successor not same as current node? true remove successor
      if succ_parent != node
        succ_parent.left = successor.right
      else 
        succ_parent.right = successor.right
      end

      # replace node with sucessor
      node.data = successor.data
    end
    return node
  end

  def find(node = @root, value)
    
    if node == nil
      return false
    end

    if value == node.data
      return true
    end
    
    # recursion for traversal
    if value < node.data
      find(node.left, value)
    elsif value > node.data
      find(node.right, value)
    end
  end


end



class Node
  attr_accessor :data, :left, :right
  include Comparable

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)

tree.pretty_print
puts "  "
puts "Insert new node and delete:"
tree.insert(2)
tree.delete(1)
tree.delete(67)
tree.pretty_print
puts tree.find(6345)
puts tree.find(16)
