# AutoSysAdmin v2 🚀

**AutoSysAdmin** is a powerful Linux automation tool designed to **simplify and streamline user and group management**. Built for system administrators and Linux enthusiasts, it reduces repetitive tasks, minimizes human errors, and enhances overall efficiency.

---

## 🌟 What's New in v2

- **Interactive colored interface** for better user experience and clarity.
- **Figlet visual effect** displaying the developer's signature on launch.
- **Advanced group management**:
  - Add new groups with automatic existence check.
  - Remove groups safely.
- **User management enhancements**:
  - Add or remove multiple users at once.
  - Display users with UID ≥ 1000.
  - **Tree view of groups and members** with their respective UIDs.
  - Reassign UIDs to users within a group.
- **Improved error handling** and informative color-coded messages.

---

## 🚀 Current Features

- Add multiple users at once, specifying a target group (created automatically if missing).
- Delete multiple users at once.
- List all existing non-system users.
- View and manage groups and their members in a clear hierarchical tree.
- Reassign UIDs for users in a selected group.

---

## 🔧 Upcoming Features

- Apply unified UID and GID policies across users and groups.
- Enforce password policies automatically.
- Lock/unlock users individually or in batches.
- Modify user shells and basic permissions programmatically.

---

## 🖥️ Usage

1. **Clone the repository**:

```bash
git clone https://github.com/mhmoudjma/AutoSysAdmin.git
cd AutoSysAdmin
