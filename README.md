# Rojo Setup

Rojo is a tool that helps connect Roblox Studio with external code editors (like VS Code) for better scripting and project management. It allows you to sync files between your local machine and Roblox Studio seamlessly.

## 📦 Prerequisites

* **Roblox Studio** installed.
* **VS Code** or another code editor installed.
* **Rojo CLI** installed ([Download here](https://github.com/rojo-rbx/rojo/releases)).

---

## ⚙️ Installation & Setup

1. **Install Rojo in VS Code**

   * Open VS Code.
   * Go to **Extensions** → Search for `Rojo` → Install.

2. **Install Rojo CLI**

   * Download the latest release from the [Rojo GitHub page](https://github.com/rojo-rbx/rojo/releases).
   * Extract and add it to your system PATH so you can run `rojo` commands from your terminal.

3. **Create a Rojo Project**

   ```bash
   rojo init
   ```

   This will create a default `default.project.json` file in your folder.

4. **Open the Project in Roblox Studio**

   * Open Roblox Studio.
   * Install the **Rojo Plugin** from the [Roblox Plugin Marketplace](https://create.roblox.com/marketplace/asset/12807918471/Rojo-Plugin).
   * In Studio, click **Rojo** → **Connect** and select the `.project.json` file.

---

## 🚀 Running Rojo

To start syncing files:

```bash
rojo serve
```

Then in Roblox Studio, connect to the server using the Rojo plugin.
Any changes you make in your code editor will update instantly in Studio.

---

## 📂 Project Structure Example

```plaintext
src/
  ServerScriptService/
    Main.server.lua
  StarterPlayer/
    PlayerScript.client.lua
default.project.json
```

You can customize the structure in `default.project.json`.

---

## ✅ Benefits of Using Rojo

* Work in your favorite editor with linting & autocomplete.
* Keep your project organized in version control (Git).
* Avoid losing scripts due to Studio crashes.

---

If you want, I can also make you a **pre-configured default.project.json** for Roblox simulator-style games so you can start right away. Would you like me to add that?
