# This wonderful code taken from http://github.com/michaeldv/awesome_print.
class String
    [:gray, :red, :green, :yellow, :blue, :purple, :cyan, :white].each_with_index do |color, i|
        define_method color          do "\033[1;#{30+i}m#{self}\033[0m" end
        define_method :"#{color}ish" do "\033[0;#{30+i}m#{self}\033[0m" end
    end
end