#!/bin/bash

if [ "$EUID" -ne 0 ] ; then
  echo "you need root"
 exit 1
 fi


echo "running ...................................." 




users=()

while true; do
    echo "==================================="
    echo " 1) Add users"
    echo " 2) Remove user"
    echo " 3) add groups "
    echo " 4) my users"
    echo " 9) Exit"
    echo "=================================="
    read -p "Choose an option: " option

    case $option in
        1)
            while true; do
                read -p "Enter username (or 'done' to finish): " username
                if [ "$username" == "done" ]; then
                    break
                fi
                if [ -z "$username" ]; then
                    echo "Please enter a valid name"
                    continue
                fi
                users+=("$username")
            done
         
          if [ ${#users[@]} -eq 0 ]; then
    echo "No users to add"
else
    for username in "${users[@]}"; do
        useradd -m -s /bin/bash -G root "$username"
        echo "User $username added successfully"
    done
fi

           ;;
        2)
            while true; do
                read -p "Enter username (or 'done' to finish): " username
                if [ "$username" == "done" ]; then
                    break
                fi
                if [ -z "$username" ]; then
                    echo "Please enter a valid name"
                    continue
                fi
                users+=("$username")
            done
         
          if [ ${#users[@]} -eq 0 ]; then
    echo "No users to remove "
else
    for username in "${users[@]}"; do
        userdel -r  "$username"
        echo "User $username remove successfully"
    done
fi
            ;;

        3) echo "coming soon "

       ;;
       4)

        awk -F: '$3 >= 1000 {print $1}' /etc/passwd
           sleep 5
               ;;
       9)
            exit
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

