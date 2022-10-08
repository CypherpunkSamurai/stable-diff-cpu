#!/bin/bash


if ! [ -x "$(command -v conda)" ]; then
	echo "Conda is not installed..."
    exit 1
elif [ -d "$HOME/miniconda3" ]; then
	echo "Conda Installation found at $HOME/miniconda3..."
    echo "Adding conda to PATH..."
	export PATH=$PATH:$HOME/miniconda3/bin
else
	echo "Conda Installation was found..."
fi

# Conda Fix
conda init bash
source ~/.bashrc

# Run
conda activate sdco
python ./webui.py --no-half
