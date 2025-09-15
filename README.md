# Smart Office IoT Capstone Lab

This repository provides a full capstone scenario for **ethical hacking students**, designed to teach them how to compromise a simulated **Smart Office IoT network**. It uses **Docker containers** to replicate a network with IoT devices, an IoT gateway, a vulnerable employee workstation, and supporting services.

---

### **Repository Structure**

The repository is organized into a clear directory structure to manage the various components of the lab.

<img width="667" height="587" alt="image" src="https://github.com/user-attachments/assets/6814b837-2da3-4f40-820c-0015e48774e5" />

---

### **Quick Start**

#### **Prerequisites**

To run this lab, you'll need a **Kali Linux VM** (or another Linux distribution) with **Docker** and **Docker Compose** installed. A machine with at least **4GB RAM** and **2 CPUs** is recommended for smooth performance.

#### **Deployment**

1.  **Clone the repository** into your Kali machine:

    ```bash
    git clone [https://github.com/cnshimba/smart-office-setup.git](https://github.com/cnshimba/smart-office-setup.git)
    cd smart-office-setup
    ```

2.  **Build and run the lab:**

    ```bash
    make build
    make up
    ```

3.  **To stop and reset** the lab environment:

    ```bash
    make down
    make reset
    ```

After startup, you can access the different lab components at the following URLs:

* **IoT Gateway:** `http://localhost:8080`
* **OmniCam v2.0:** `http://localhost:8081`
* **ClimateMaster 3000:** `http://localhost:8082`
* **Employee Workstation:** Accessible via SSH/Web through the internal Docker network.

---

### **Challenges Overview**

The capstone lab is structured as a series of **"Capture the Flag" (CTF)**-style challenges, with flags hidden in the `services/flags/` directory that students must uncover through various exploits.

* **Recon & OSINT:** Utilize tools like Shodan, Nmap, and bash scripting to gather information.
* **Web Exploits:** Find and exploit vulnerabilities such as **SQL Injection (SQLi)**, **Cross-Site Scripting (XSS)**, and weak configurations.
* **Internal Pivoting:** Pivot from an external breach to the internal network using techniques like **SMB shares**, **ARP spoofing**, and **Scapy probes**.
* **Social Engineering:** Practice social engineering with tools like **SET (Social-Engineer Toolkit)** for phishing and **BeEF** for browser hooking.
* **Reporting:** Complete the final deliverable by writing a professional **penetration testing report**, prioritizing findings based on their severity.

---

### **Documentation and License**

The repository includes comprehensive documentation to support both students and instructors:

* **Student Instructions:** A guide to the challenge format.
* **Instructor Guide:** Provides solution steps and expected flags for each challenge.
* **Grading Rubric:** Outlines the criteria for assessing student performance.
* **Report Template:** A template to help students structure their final penetration test report.

This lab is intended for **educational use only** and should **not be deployed in production environments**.
