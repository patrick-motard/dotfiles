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
   chezmoi apply
   ```

   **Note**: Machine-specific configurations (for example, work vs. personal machines) are automatically determined by hostname inside templates.

3. **Install ZSH plugins**:
   ```shell
   zplug install
   ```

4. **Install tmux plugins**:
   - Open tmux: `tmux`
   - Press `Ctrl+t` then `I` (capital I) to install TPM plugins

5. **Restart your terminal** to see the new theme and configuration take effect.
