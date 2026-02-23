import pexpect
import sys

def main():
    try:
        child = pexpect.spawn('ssh -o StrictHostKeyChecking=no root@188.132.198.189')
        child.expect('[P|p]assword:')
        child.sendline('Kamulog.34')
        child.expect('[#\$]')
        child.sendline('cd /var/www && ls -la')
        child.expect('[#\$]')
        print("--- VAR WWW ---")
        print(child.before.decode())
        
        child.sendline('cd /root && ls -la')
        child.expect('[#\$]')
        print("--- ROOT ---")
        print(child.before.decode())
        
        child.sendline('pm2 list')
        child.expect('[#\$]')
        print("--- PM2 ---")
        print(child.before.decode())
        
        child.close()
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    main()
