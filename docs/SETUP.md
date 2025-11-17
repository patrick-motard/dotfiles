# Initial Setup

## New Machine Setup

1. **Install Chezmoi** and initialize with this repo:
   ```shell
   # Install chezmoi (macOS)
   brew install chezmoi

   # Initialize with your dotfiles repo
   chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
   ```

2. **Apply dotfiles**:
   ```shell
   # Apply all dotfiles
   chezmoi apply
   ```

   **Note**: Machine-specific configurations (e.g., for work vs. personal machines) are automatically determined by your hostname. No manual configuration is needed. Templates will use `{{ .chezmoi.hostname }}` to apply machine-specific settings.

3. **Install ZSH plugins**:
   ```shell
   # Install zplug plugins (including agnoster theme)
   zplug install
   ```

4. **Run Ansible** to install packages and configure system:
   ```shell
   # macOS
   ./ansible/mac-setup.sh  # First time only
   dotansible

   # Linux/Fedora
   ./ansible/fedora-setup.sh  # First time only
   ```

5. **Restart your terminal** to see the new theme and configuration take effect.
