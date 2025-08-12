## MacOS Installation Instructions

1. **Download and unzip** the contents of the `macos/` folder to any location on your Mac.
   - Go back to **Symbolic-Regression-ASB2025**, click `<>Code`, and click **Download Zip File**.

3. **Open Terminal** and **navigate to the app directory** (where you extracted the files).  
   Replace the path if needed, for example:

   ```bash
   cd ~/Downloads/SR/PySR\ GUI

4. Make the installer executable and run it. Your laptop password may be requested.
   ```bash
    chmod +x installer.sh
    ./installer.sh

5. Once the installation is complete, you will see the following message in the terminal:
   
   All installations complete!
   
   You can now run ./start_app.sh

6. Go to System Settings → General → AirDrop & Handoff

   Turn AirPlay Receiver off

7. Make the app launcher executable and start the app:
   ```bash
    chmod +x start_app.sh
    ./start_app.sh
 8. Open the app

   If the app does not open automatically, open a browser (preferably Google Chrome) and go to:
   
   http://localhost:5000
