#echo "Enter two numbers separated by an aritmetic operator"
#echo "note use  for multiplication rather than "
echo "Enter two numbers and an operator in this form \"2 x 3\" and press enter"
read one  operator two

case $operator in
    '+')
        echo -n -e "\e[34m$one + $two = \e[0m" 
        echo -e "\e[34m`expr $one + $two`\e[0m" 
        ;;
    '-')
        echo -n -e "\e[31m$one - $two = \e[0m"  
        echo -e "\e[31m`expr $one - $two`\e[0m" 
        ;;
     'x')
        echo -e -n "\e[32m$one x $two = \e[0m"       
        echo -e "\e[32m`expr $one \* $two`\e[0m" 
        ;;
     '/')
        echo -e -n "\e[35m$one / $two = \e[0m"       
        echo -e "\e[35m`expr $one / $two`\e[0m"
        ;;      
    *)
        echo "Invalid input"
        exit 1
esac
