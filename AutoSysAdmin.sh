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
            # اطلب من المستخدم يحدد الجروب
            read -p "Enter the group name to add users to: " groupname

            # تحقق اذا الجروب موجود، لو مش موجود اعمله
            if ! getent group "$groupname" > /dev/null 2>&1; then
                echo "Group $groupname does not exist. Creating it..."
                groupadd "$groupname"
                echo "Group $groupname created successfully."
            fi

            # ادخال اليوزرز
            users=()
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
                    useradd -m -s /bin/bash -G "$groupname" "$username"
                    echo "User $username added successfully to group $groupname"
                done
            fi
            ;;
        2)
            users=()
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
                    userdel -r "$username"
                    echo "User $username removed successfully"
                done
            fi
            ;;
        3) 
            echo "coming soon "
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
