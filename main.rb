class Tree
  attr_accessor :root

  def initialize(array)
    p array = array.sort.uniq
    @root = build_tree(array)
  end

  # Recursively builds a sorted tree
  def build_tree(array)
    return nil if array.length == 0

    middle = array.length / 2
    root = Node.new(array[middle])
    root.left = build_tree(array[0...middle])
    root.right = build_tree(array[middle + 1..-1])
    root
  end

  # Prints tree to console
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  # Inserts nodes as leaves
  def insert(node = @root, value)
    return node = Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(node.left, value)
    elsif value > node.data
      node.right = insert(node.right, value)
    end

    node
  end

  def delete(node = @root, value)
    return node if node.nil?

    # Recursion for traversal
    if value < node.data
      node.left = delete(node.left, value)
      return node
    elsif value > node.data
      node.right = delete(node.right, value)
      return node
    end

    # One or no child
    if node.left.nil?
      return node.right
    elsif node.right.nil?
      return node.left
    # Two children
    else
      succ_parent = node
      successor = node.right
      # Finds successor
      until successor.left.nil?
        succ_parent = successor
        successor = successor.left
      end

      # Check if parrent of successor is not same as current node 
      if succ_parent != node
        succ_parent.left = successor.right
      else
        succ_parent.right = successor.right
      end

      # Replace node with sucessor
      node.data = successor.data
    end

    node
  end

  def find(node = @root, value)
    return false if node.nil?

    return true if value == node.data

    if value < node.data
      find(node.left, value)
    elsif value > node.data
      find(node.right, value)
    end
  end

  # Traverse tree through level order
  def level_order(node = @root)
    return nil if node.nil?

    queue = [node]
    output = []
    until queue.empty?
      # Pull node out of queue to process children and value
      current = queue.shift
      output << current.data
      # Queues data
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    output
  end

  # DLR Traversal
  def preorder(node = @root)
    return [] if node.nil?

    result = []
    result << node.data

    result += preorder(node.left)
    result += preorder(node.right)

    result
  end

  # LDR Traversal
  def inorder(node = @root)
    return [] if node.nil?

    result = []

    result += inorder(node.left)
    result << node.data
    result += inorder(node.right)

    result
  end

  # LRD Traversal
  def postorder(node = @root)
    return [] if node.nil?

    result = []

    result += postorder(node.left)
    result += postorder(node.right)
    result << node.data

    result
  end

  # Height of root to leaf
  def height(node = @root, count = -1)
    return count if node.nil?

    left = height(node.left, count + 1)
    right = height(node.right, count + 1)

    [left, right].max
  end
  
  # Depth of a node
  def depth(node = @root, counter = 0, value)
    return -1 if node.nil?

    return counter if node.data == value

    if value < node.data
      depth(node.left, counter + 1, value)
    elsif value > node.data
      depth(node.right, counter + 1, value)
    end
  end

  # Compare both sides with help function
  def balanced?(node = @root)
    return true if node.nil?

    left = height(node.left)
    right = height(node.right)

    return false if (left - right).abs > 1

    balanced?(node.left) && balanced?(node.right)
  end

  def rebalanced
    @root = build_tree(level_order.sort.uniq)
    pretty_print
  end
end

# Create node objects with left and right
class Node
  attr_accessor :data, :left, :right

  include Comparable

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# Test Driver Script
array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
puts 'Initial tree:'
tree.pretty_print
puts "Balanced: #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Inorder: #{tree.inorder}"
puts "Postorder: #{tree.postorder}"

puts 'Insert Nodes:'
tree.insert(150)
tree.insert(200)
tree.insert(175)
tree.pretty_print
puts "Balanced: #{tree.balanced?}"

puts 'Rebalance:'
tree.rebalanced
puts "Balanced: #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Inorder: #{tree.inorder}"
puts "Postorder: #{tree.postorder}"
