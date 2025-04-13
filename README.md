# Fast and Smooth

This repository contains scripts to quickly and easily set up your Windows Server and Active Directory (AD). First, open `powershell.exe` and use `Set-ExecutionPolicy -Unrestricted`
It's important to note that this setting reduces the security of your system by allowing all scripts to run. It might be beneficial to mention that this setting can be reverted to a more secure state after the scripts have been executed. Each script needs to be executed manually, one after the other. The scripts should be executed in the following order:

## 1. setting_up_srv.ps1:
- Prompts for:

    - hostname
    - IP address
    - Subnet prefix
    - Default gateway
    - DNS address

- Performs the following actions: 

    - Renames the server.
    - Configures IP settings (IP address, subnet prefix, default gateway).
    - Sets the DNS server.
    - Renames the network adapter.
    - Enables Remote Desktop and configures the firewall.
    - Prompts for a restart to apply changes.


## 2. add_features.ps1:
- Installs the following features:

    - Active Directory Domain Services (ADDS)
    - DNS
    - Remote Server Administration Tools (RSAT)

## 3. forest_config.ps1
- Prompts for: 

    - Domain Name (e.g., example.com)
    - Domain NetBios Name

- Performs the following actions:

    - Imports the ADDSDeployment module.
    - Configures the forest with the specified domain name and NetBios name.
    - Sets various forest configuration parameters such as database path, log    path, and sysvol path.
    - Installs DNS as part of the forest configuration.
    - Prevents automatic reboot upon completion.


# Injection

## AD_addusers.ps1

This PowerShell script automates the creation of Organizational Units (OUs) and users in Active Directory (AD) based on data from a CSV file. The script performs the following actions:

### 1. Prerequisites

- Ensure the Active Directory module is available on the system where the script is executed.
- Prepare a CSV file (users.csv) with user data, including columns for first_name, last_name, and password.

### 2. Usage

- Place the users.csv file in the same directory as the script or adapt the script to point to the correct location of the CSV file.
- Ensure the script has the necessary permissions to create OUs and users in Active Directory.
- Execute the script in a PowerShell environment with the Active Directory module available.

### 3. Script Overview

##### - Input

- CSV File: The script reads user data from your .csv file. Ensure the file is in the correct format and accessible.


##### - Actions Performed

- Import CSV Data:
    - Reads user data from the specified CSV file.

##### - Import Active Directory Module:

- Imports the Active Directory module to manage AD operations.

##### - Define Base OU Path:

- Sets the base path for OUs as DC=dinoland,DC=lan.

##### - Create Organizational Units (OUs):

- Creates the main OU "CORE" under the base path.
- Creates the "HUMANS" OU under "CORE".
- Creates "USERS" and "ADMIN" OUs under "HUMANS".

##### - Process CSV Data to Create Users:

- Iterates through the CSV data to create users in AD.
- Determines the target OU based on the user index (first 200 users go to "USERS", others to "ADMIN").
- Checks for missing first name or last name and skips such entries.
- Creates users with the specified attributes (name, email, password) if they do not already exist in AD.

### 4. Error Handling

- The script includes error handling for OU and user creation, with warnings and a pause of 5 seconds for errors.

### 5. Output

- The script outputs the status of OU and user creation to the console, indicating success or any errors encountered.
