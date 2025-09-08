# FXServer Multi Profiles (Batch Script) [Windows Only]

**A simple and convenient utility for launching and creating FXServer profiles on Windows.**

This script works like an enhanced FXServer launcher:

- Quickly and easily launches the selected server profile.  
- Allows you to create new profiles with name validation.   

With this script, you can easily:

- Launch the selected server profile.  
- Create new profiles without unnecessary steps.  
- Manage all profiles from a single convenient menu.  

---

## ⚙️ Installation

1. Copy the `FXMultiProfiles.bat` file to your FXServer folder.  
2. Make sure that in the same folder as the script there is an `artifact` folder containing `FXServer.exe`.  
3. Optionally, you can change the `TXHOST_DATA_PATH` variable in the script if you want your profiles (`txData`) to be stored in a custom location:  

```bat
set TXHOST_DATA_PATH=D:/your/path/to/txData
```

## 🚀 Usage

Double-click the `FXMultiProfiles.bat` file.

The menu will automatically display available profiles or prompt to create a new one.

Select a profile or create a new one — the script will validate the name (only Latin letters and digits, no spaces).

The script will launch `FXServer.exe` with the selected profile.

---

## 📄 License

MIT License — free to use, modify, and distribute.
