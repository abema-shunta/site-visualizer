nodes = open "./csv/nodes.csv"
links = open "./csv/links.csv"
data = open "data.coffee", "w"

nodeMax = 0
linkMax = 0

data.puts "nodes = ["

nodes.each_with_index do |line, i|
  unless i==0
    items = line.chomp.split(",")
    data.puts "  {"
    data.puts "    id: #{items[0].to_i - 1}"
    data.puts "    path: \"#{items[1].gsub("\"","'").chomp}\""
    data.puts "    title: \"#{items[2].gsub("\"","'").chomp}\""
    data.puts "    volume: #{items[3]}"
    data.puts "  }"
    nodeMax = items[3].to_i > nodeMax ? items[3].to_i : nodeMax
  end
end

data.puts "]"

data.puts "nodeMax = #{nodeMax}"

data.puts "links = ["

links.each_with_index do |line, i|
  unless i==0
    items = line.chomp.split(",")
    data.puts "  {"
    data.puts "    source: #{items[1].to_i - 1}"
    data.puts "    target: #{items[3].to_i - 1}"
    data.puts "    volume: #{items[4]}"
    data.puts "  }"
    linkMax = items[4].to_i > linkMax ? items[4].to_i : linkMax
  end
end

data.puts "]"

data.puts "linkMax = #{linkMax}"
