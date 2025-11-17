# Initial Setup

## New Machine Setup

1. **Install Chezmoi** and initialize with this repo:
   ```shell
   # Install chezmoi (macOS)
   brew install chezmoi

   # Initialize with your dotfiles repo
   chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
   ```

2. **Configure machine-specific settings**:

   After initialization, chezmoi will create `~/.config/chezmoi/chezmoi.toml` with default values. Edit this file to set your machine profile:

   ```shell
   # Edit the config file
   vim ~/.config/chezmoi/chezmoi.toml
   ```

   Set the appropriate profile for your machine:
   ```toml
   [data]
       # Examples: "personal-mac", "zendesk-mac", "personal-linux", "zendesk-linux"
       # You can create profiles for different employers/contexts
       machine_profile = "personal-mac"
   ```

   **Example profiles**:
   - `"personal-mac"` - Personal macOS machine (default)
   - `"zendesk-mac"` - Zendesk macOS machine (includes zetup, zendesk tooling, work SSH keys, etc.)
   - `"personal-linux"` - Personal Linux/WSL machine
   - `"zendesk-linux"` - Zendesk Linux/WSL machine
   - Or create custom profiles for other employers/contexts (e.g., `"acme-corp-mac"`)

   This flexible profile system allows different package sets and configurations per machine type and employer context, making it easy to maintain multiple work machines and personal machines from the same repository.

3. **Apply dotfiles**:
   ```shell
   # Apply all dotfiles
   chezmoi apply
   ```

4. **Install ZSH plugins**:
   ```shell
   # Install zplug plugins (including agnoster theme)
   zplug install
   ```

5. **Run Ansible** to install packages and configure system:
   ```shell
   # macOS
   ./ansible/mac-setup.sh  # First time only
   dotansible

   # Linux/Fedora
   ./ansible/fedora-setup.sh  # First time only
   ```

6. **Restart your terminal** to see the new theme and configuration take effect.
