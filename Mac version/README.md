## MacOS Installation Instructions

1. **Download and unzip** the contents of the `macos/` folder to any location on your Mac.

2. **Open Terminal** and **navigate to the app directory** (where you extracted the files).  
   Replace the path if needed:

   ```bash
   cd ~/Downloads/SR/PySR\ GUI

3. Make the installer executable and run it
   ```bash
    chmod +x installer.sh
    ./installer.sh

4. Once the installation is complete, you will see the following message in the terminal:
   
   All installations complete!
   
   You can now run ./start_app.sh

5. Go to System Settings → General → AirDrop & Handoff

   Turn AirPlay Receiver off

6. Make the app launcher executable and start the app:
   ```bash
    chmod +x start_app.sh
    ./start_app.sh
 7. Open the app

   If the app does not open automatically, open a browser (preferably Google Chrome) and go to:
   
   http://localhost:5000
