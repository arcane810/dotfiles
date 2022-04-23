#!/bin/bash

# Install packages
echo "Installing required packages"
sudo pacman -S bspwm sxhkd alacritty rofi picom

# Directory of repo
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

######################
#### BSPWM, SXHKD ####
######################

chmod +x "${script_dir}/bspwmrc"

declare -A packages=( ["bspwm"]="bspwmrc" ["sxhkd"]="sxhkdrc" ["rofi"]="config.rasi" ["picom"]="picom.conf" ["alacritty"]="alacritty.yml" )

for package_name in ${!packages[@]}; do
    echo "Linking ${package_name} config... "
    file_dir="${HOME}/.config/${package_name}"
    file_path="${file_dir}/${packages[${package_name}]}"
    
    if [ -f "${file_path}" ] || [ -L "${file_path}" ]
    then
        echo "${file_path} already exists. Copying old file to ${file_path}.lf.old"
        cp -P ${file_path} "${file_path}.lf.old"
        rm ${file_path}
    fi
    
    mkdir -p ${file_dir}
    ln -s "${script_dir}/${package_name}/${packages[${package_name}]}" "${file_path}"
    
    echo "Done"
done
