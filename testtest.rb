message = "             \e[1;31mjava.lang.RuntimeException\e[m: \e[3mUnable to resolve symbol: sofij in this context\e[m\n\e[1;31mclojure.lang.Compiler$CompilerException\e[m: \e[3mjava.lang.RuntimeException: Unable to resolve symbol: sofij in this context,"

submessage = "firsthalf\e[1;31mjava.lang.RuntimeException"

p submessage.gsub(/\e.*m/, '')
# leaves an e behind when removing that... \e to m code

# p message.
#   gsub('"', '\"').
#   gsub(/\\e.*m/, '').
#   split("\n").last
