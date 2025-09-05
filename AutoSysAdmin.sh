#!/bin/bash

# ألوان
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[37m"
RESET="\e[0m"

# التحقق من الصلاحيات
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}You need root privileges to run this script.${RESET}"
  exit 1
fi

for i in {1..3}; do
    clear
    echo -e "${GREEN}"
    figlet "mhmoud jma"
    echo -e "${RESET}"
    sleep 0.6
    clear
    sleep 0.3
done
#echo -e "${CYAN}==================================="
#echo -e "${MAGENTA}        mhmoud-jma        "
#echo -e "${MAGENTA}        mhmoud-jma        "
#echo -e "${MAGENTA}        mhmoud-jma        "
#echo -e "${CYAN}===================================${RESET}"

users=()

while true; do
    echo -e "${YELLOW}==================================="
    echo -e " ${GREEN}1) Add users"
    echo -e " ${GREEN}2) Remove users"
    echo -e " ${GREEN}3) Add groups"
    echo -e " ${GREEN}4) List users"
    echo -e " ${GREEN}5) UID managed"
    echo -e " ${GREEN}6) Remove groups"
    echo -e " ${RED}9) Exit"
    echo -e "${YELLOW}===================================${RESET}"
    read -p "Choose an option: " option

    case $option in
        1)  # إضافة يوزرز
            read -p "Enter the group name to add users to: " groupname
            if ! getent group "$groupname" > /dev/null 2>&1; then
                echo -e "${BLUE}Group $groupname does not exist. Creating it...${RESET}"
                groupadd "$groupname"
                echo -e "${GREEN}Group $groupname created successfully.${RESET}"
            fi

            users=()
            while true; do
                read -p "Enter username (or 'done' to finish): " username
                if [ "$username" == "done" ]; then
                    break
                fi
                if [ -z "$username" ]; then
                    echo -e "${RED}Please enter a valid name${RESET}"
                    continue
                fi
                users+=("$username")
            done

            if [ ${#users[@]} -eq 0 ]; then
                echo -e "${YELLOW}No users to add${RESET}"
            else
                for username in "${users[@]}"; do
                    useradd -m -s /bin/bash -G "$groupname" "$username"
                    echo -e "${GREEN}User $username added successfully to group $groupname${RESET}"
                done
            fi
            ;;
        2)  # إزالة يوزرز
            users=()
            while true; do
                read -p "Enter username (or 'done' to finish): " username
                if [ "$username" == "done" ]; then
                    break
                fi
                if [ -z "$username" ]; then
                    echo -e "${RED}Please enter a valid name${RESET}"
                    continue
                fi
                users+=("$username")
            done

            if [ ${#users[@]} -eq 0 ]; then
                echo -e "${YELLOW}No users to remove${RESET}"
            else
                for username in "${users[@]}"; do
                    userdel -r "$username"
                    echo -e "${GREEN}User $username removed successfully${RESET}"
                done
            fi
            ;;
        3)  # إضافة جروب
            read -p "Enter the name of the group: " group
            if ! getent group "$group" > /dev/null 2>&1; then
                groupadd "$group"
                echo -e "${GREEN}Group $group added successfully${RESET}"
            else
                echo -e "${YELLOW}Group $group already exists${RESET}"
            fi
            ;;
        4)  # عرض جميع المستخدمين العاديين
            echo -e "${CYAN}List of users with UID >= 1000:${RESET}"
            awk -F: '$3 >= 1000 {print $1}' /etc/passwd
            sleep 2
            ;;
        5)  # إدارة UID
            echo -e "${CYAN}===== Group Tree with UIDs (GID >= 1000) =====${RESET}"
            groups_list=$(awk -F: '$3 >= 1000 {print $1":"$3}' /etc/group)

            i=1
            declare -A group_map
            while IFS=: read -r grp gid; do
                members=$(getent group "$grp" | awk -F: '{print $4}')
                if [ -n "$members" ]; then
                    echo -e "${MAGENTA}$i) $grp (GID: $gid)${RESET}"
                    IFS=',' read -ra arr <<< "$members"
                    for user in "${arr[@]}"; do
                        uid=$(id -u "$user" 2>/dev/null)
                        if [ -n "$uid" ]; then
                            echo -e "   └─ ${BLUE}$user (UID: $uid)${RESET}"
                        fi
                    done
                    group_map[$i]="$grp"
                    ((i++))
                fi
            done <<< "$groups_list"

            if [ ${#group_map[@]} -eq 0 ]; then
                echo -e "${YELLOW}No valid groups found.${RESET}"
                continue
            fi

            echo
            read -p "Select group number to reassign UIDs (or 0 to cancel): " grp_num
            if [ "$grp_num" -eq 0 ]; then
                continue
            fi

            grp_name=${group_map[$grp_num]}
            if [ -z "$grp_name" ]; then
                echo -e "${RED}Invalid group number.${RESET}"
                continue
            fi

            members=$(getent group "$grp_name" | awk -F: '{print $4}')
            if [ -z "$members" ]; then
                echo -e "${YELLOW}No members in group $grp_name.${RESET}"
                continue
            fi

            read -p "Enter starting UID: " start_uid
            if ! [[ "$start_uid" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}Invalid UID${RESET}"
                continue
            fi

            current_uid=$start_uid
            IFS=',' read -ra arr <<< "$members"
            for user in "${arr[@]}"; do
                if id "$user" &>/dev/null; then
                    usermod -u "$current_uid" "$user"
                    echo -e "${GREEN}User $user assigned UID $current_uid${RESET}"
                    ((current_uid++))
                fi
            done
            ;;
        6)  # إزالة جروب
            read -p "Enter group name to remove: " del_group
            if getent group "$del_group" > /dev/null 2>&1; then
                groupdel "$del_group"
                echo -e "${GREEN}Group $del_group removed successfully.${RESET}"
            else
                echo -e "${YELLOW}Group $del_group does not exist.${RESET}"
            fi
            ;;
        9)
            echo -e "${CYAN}Exiting script.${RESET}"
            exit
            ;;
        *)
            echo -e "${RED}Invalid option, please choose again.${RESET}"
            ;;
    esac
done
