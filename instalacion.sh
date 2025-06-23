#!/bin/bash

known_compatible_distros=(
                        "Ubuntu"
                        "Debian"
                        "Arch"
                        "Manjaro"
                    )

function detect_distro_phase() 
{
    for i in "${known_compatible_distros[@]}"; 
    do
        uname -a | grep "${i}" -i > /dev/null
        if [ "$?" = "0" ]; 
            then
                distro="${i^}"
                break
        fi
    done
}

function detect_gnome()
{
    ps -e | grep -E '^.* gnome-session$' > /dev/null
    if [ $? -ne 0 ];
        then
            return 0
    fi
    VERSION=`gnome-session --version | awk '{print $2}'`
    DESKTOP="GNOME"
    return 1
}

detect_distro_phase

case $distro in

    Ubuntu | Debian)

        echo "----------------------------------------"
        echo ">       [1/12] Updating System         <"
        echo "----------------------------------------"
        yes | sudo apt update && sudo apt upgrade && sudo apt install git

        echo "------------------------------------------"
        echo ">       [2/12] Installing Homebrew         <"
        echo "------------------------------------------"
        sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo "---------------------------------------------"
        echo ">       [3/12] Installing Google Chrome        <"
        echo "---------------------------------------------"
        yes | sudo brew install --cask google-chrome

        if detect_gnome;
            then
                echo "------------------------------------------------"
                echo ">       [4/12] Installing Gnome Tweaks         <"
                echo "------------------------------------------------"
                yes | sudo apt install gnome-tweaks
                gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
        else
            echo "------------------------------------------------------------------"
            echo ">       [4/10] Gnome not detected, skipping gnome-tweaks         <"
            echo "------------------------------------------------------------------"
        fi

        echo "------------------------------------------"
        echo ">       [5/12] Installing VSCode         <"
        echo "------------------------------------------"
        yes | sudo brew install --cask visual-studio-code

        echo "-------------------------------------------"
        echo ">       [6/12] Installing Spotify         <"
        echo "-------------------------------------------"
        yes | sudo brew install --cask spotify

        echo "-------------------------------------------"
        echo ">       [7/12] Installing Jetbrains-toolbox  <"
        echo "-------------------------------------------"
        yes | sudo brew install --cask jetbrains-toolbox

        echo "---------------------------------------------"
        echo ">       [8/12] Installing Warp         	  <"
        echo "---------------------------------------------"
        yes | sudo brew install --cask warp

		echo "---------------------------------------------"
        echo ">       [9/12] Installing NVM       	  <"
        echo "---------------------------------------------"
        yes | sudo brew install nvm

		echo "---------------------------------------------"
        echo ">       [10/12] Installing Python     	  <"
        echo "---------------------------------------------"
        yes | sudo brew install python@3.13

		echo "---------------------------------------------"
        echo ">       [11/12] Installing Utilities   	  <"
        echo "---------------------------------------------"
        yes | sudo brew install htop neofetch tree wget curl zip unzip vim

        echo "-------------------------------------------------------------"
        echo ">       [12/12] Installing ZSH Shell and ZSH plugins        <"
        echo "-------------------------------------------------------------"
        yes | sudo brew install zsh
		yes | sudo brew install oh-my-posh
		yes | sudi sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    

        # echo "-----------------------------------------------------------"
        # echo ">       [13/12] Updating .bashrc and .zshrc files         <"
        # echo "-----------------------------------------------------------"
        # echo -e '\n' >> ~/.bashrc
        # echo '# Your aliases' >> ~/.bashrc
        # echo 'alias cls="clear"' >> ~/.bashrc
        # echo 'alias update="sudo apt update && sudo apt upgrade"' >> ~/.bashrc
        # echo 'Added aliases to .bashrc'
        # echo -e '\n' >> ~/.zshrc
        # echo '# Your aliases' >> ~/.zshrc
        # echo 'alias cls="clear"' >> ~/.zshrc
        # echo 'alias update="sudo apt update && sudo apt upgrade"' >> ~/.zshrc
        # echo 'Added aliases to .zshrc'
        # git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
        # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        # sed -i '/^ZSH_THEME=/s/=.*/="powerlevel10k\/powerlevel10k"/' ~/.zshrc
        # echo 'Set ZSH theme to Powerlevel10k'
        # sed -i '/^plugins=/s/=.*/=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
        # echo 'Updated new plugins in .zshrc'

        # echo "--------------------------------------------------------"
        # echo "> Authentication required for making ZSH defualt shell <"
        # echo "--------------------------------------------------------"
        # chsh -s /usr/bin/zsh

        echo "------------------------------------------------"
        echo ">       Phew, saved you a lot of time!         <"
        echo "------------------------------------------------"
        ;;
    
    Arch | Manjaro)

        echo "---------------------------------------"
        echo ">       [1/10] Updating System         <"
        echo "---------------------------------------"
        yes | sudo pacman -Syu
        sudo pacman -S git

        echo "------------------------------------------"
        echo ">       [2/10] Installing Firefox         <"
        echo "------------------------------------------"
        sudo pacman -S firefox

        echo "--------------------------------------------"
        echo ">       [3/10] Removing LibreOffice         <"
        echo "--------------------------------------------"
        yes | sudo pacman -Rs libreoffice

        if detect_gnome;
            then
                echo "-----------------------------------------------"
                echo ">       [4/10] Installing Gnome Tweaks         <"
                echo "-----------------------------------------------"
                yes | sudo pacman -S gnome-tweaks
                gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
        else
            echo "------------------------------------------------------------------"
            echo ">       [4/10] Gnome not detected, skipping gnome-tweaks         <"
            echo "------------------------------------------------------------------"
        fi

        echo "-----------------------------------------"
        echo ">       [5/10] Installing VSCode         <"
        echo "-----------------------------------------"
        cd ~/Downloads
        git clone https://AUR.archlinux.org/visual-studio-code-bin.git
        cd visual-studio-code-bin/
        makepkg -s
        yes | sudo pacman -U visual-studio-code-bin-*.pkg.tar.xz
        cd ../ && sudo rm -rfv visual-studio-code-bin/

        echo "------------------------------------------"
        echo ">       [6/10] Installing Spotify         <"
        echo "------------------------------------------"
        yes | sudo pacman -Sy flatpak
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub com.spotify.Client


        echo "-------------------------------------------------------------"
        echo ">       [9/10] Installing ZSH Shell and ZSH plugins        <"
        echo "-------------------------------------------------------------"
        yes | sudo pacman -S zsh
        yes n | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

        # echo "----------------------------------------------------------"
        # echo ">       [10/10] Adding your bash and zsh aliases         <"
        # echo "----------------------------------------------------------"
        # echo -e '\n' >> ~/.bashrc
        # echo '# Your aliases' >> ~/.bashrc
        # echo 'alias cls="clear"' >> ~/.bashrc
        # echo 'alias update="sudo apt update && sudo apt upgrade"' >> ~/.bashrc
        # echo 'Added aliases to .bashrc'
        # echo -e '\n' >> ~/.zshrc
        # echo '# Your aliases' >> ~/.zshrc
        # echo 'alias cls="clear"' >> ~/.zshrc
        # echo 'alias update="sudo apt update && sudo apt upgrade"' >> ~/.zshrc
        # echo 'Added aliases to .zshrc'
        # git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
        # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        # sed -i '/^ZSH_THEME=/s/=.*/="powerlevel10k\/powerlevel10k"/' ~/.zshrc
        # echo 'Set ZSH theme to Powerlevel10k'
        # sed -i '/^plugins=/s/=.*/=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
        # echo 'Updated new plugins in .zshrc'

        echo "--------------------------------------------------------"
        echo "> Authentication required for making ZSH defualt shell <"
        echo "--------------------------------------------------------"
        chsh -s /usr/bin/zsh

        echo "------------------------------------------------"
        echo ">       Phew, saved you a lot of time!         <"
        echo "------------------------------------------------"
        ;;

esac