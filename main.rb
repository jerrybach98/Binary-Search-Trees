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
    
    if value < node.data
      find(node.left, value)
    elsif value > node.data
      find(node.right, value)
    end
  end

  # traverse and display breadth-first level order, use recursion or iteration, return an array of values
  # use array with queue to keep track of nodes
  def level_order(node = @root)
    # check if empty
    if node == nil
      return nil
    end

    queue = [node]
    output = []
    until queue.empty?
      # pull node out of queue to process children and value
      current = queue.shift
      output << current.data
      # queues data
      if current.left != nil 
        queue << current.left
      end
      if current.right != nil
        queue << current.right
      end
    end
    output
  end

  # Visit data, Left subtree, right subtree
  # top down all the way left, once data.left nil, parents right
  def preorder(node = @root)
    if node == nil
      return []
    end
    
    result = []
    result << node.data
    
    result += preorder(node.left)
    result += preorder(node.right)

    return result
  end

  # go all the way down left
  # print left, parent, right
  def inorder (node = @root)
    if node == nil
      return []
    end

    result = []
    
    result += inorder(node.left)
    result << node.data
    result += inorder(node.right)

    return result

  end

  # left, right, data
  def postorder(node = @root)
    if node == nil
      return []
    end

    result = []
    
    result += postorder(node.left)
    result += postorder(node.right)
    result << node.data

    return result
  end

  # find the height of the tree
  def height(node = @root, count = -1)
    if node == nil
      return count
    end

    left = height(node.left, count + 1)
    right = height(node.right, count + 1)

    return [left, right].max

  end

  def depth(node = @root, counter = 0, value)
    if node == nil
      return -1
    end

    if node.data == value 
      return counter
    end
    
    if value < node.data
      depth(node.left, counter + 1, value)
    elsif value > node.data
      depth(node.right, counter + 1, value)
    end
  end

  # use height helper function, compare sides
  def balanced?(node = @root)
    if node == nil 
      return true
    end

    left = height(node.left)
    right = height(node.right)

    if (left - right).abs > 1
      return false
    end

    balanced?(node.left) && balanced?(node.right)
  end

  # grab values from tree through a traversal method, use build tree a self balancing method
  def rebalanced()
    @root = build_tree(level_order.sort.uniq)
    pretty_print()
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


# debug comments and make new tree
# array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# tree = Tree.new(array)
# tree.pretty_print
# puts "  "
# puts "Insert new node and delete:"
# tree.insert(2)
# tree.delete(1)
# tree.delete(67)
# tree.pretty_print
# puts tree.find(6345)
# puts tree.find(16)
# p "Level order: #{tree.level_order}"
# puts "Preorder: #{tree.preorder}"
# puts "Inorder: #{tree.inorder}"
# puts "Postorder: #{tree.postorder}"
# puts "Tree height: #{tree.height}"
# puts "Node depth: #{tree.depth(8)}"
# puts "Node depth: #{tree.depth(2)}"
# puts tree.balanced?
# tree.rebalanced

# Test Driver Script
array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
puts "Initial tree:"
tree.pretty_print
puts "Balanced: #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Inorder: #{tree.inorder}"
puts "Postorder: #{tree.postorder}"

puts "Insert Nodes:"
tree.insert(150)
tree.insert(200)
tree.insert(175)
tree.pretty_print
puts "Balanced: #{tree.balanced?}"

puts "Rebalance:"
tree.rebalanced
puts "Balanced: #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Inorder: #{tree.inorder}"
puts "Postorder: #{tree.postorder}"