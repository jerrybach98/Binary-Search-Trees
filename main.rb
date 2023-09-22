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
puts "  "
tree.insert(2)
tree.pretty_print