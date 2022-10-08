#!/bin/bash

echo This Script is now installing a Stable Diffusion cpu only variant. 



# Git lfs for huggingface clones ( not required)
#sudo apt-get install git-lfs
# git lfs install



# Download Models

# Auth using Huggingface Token
# - We use EasyDiffusion Auth
AUTH="$(curl -Ls https://raw.githubusercontent.com/WASasquatch/easydiffusion/main/key.txt)"
if [ -z "$AUTH" ]; then
	AUTH="EasyDiffusioN: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"
fi

# Clone Model using Git (no required)
# git clone "https://$AUTH@huggingface.co/CompVis/stable-diffusion-v-1-4-original"

# We now use Wget instead of git
if [ ! -f "GFPGANv1.3.pth" ]; then
	wget "https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth"
    echo Download complete...
else
    echo "GFPGANv1.3.pth was found..."
fi
if [ ! -f "sd-v1-4.ckpt" ]; then
	wget "https://$AUTH@huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt"
    echo Download complete
else
	echo "sd-v1-4.ckpt was found..."
fi



# Create Directories
mkdir -p models/ldm/stable-diffusion-v1/
mkdir -p outputs/extras-samples
mkdir -p outputs/img2img-samples/samples
mkdir -p outputs/txt2img-samples/samples


# Install Conda
echo "Checking for conda installation..."
if ! [ -x "$(command -v conda)" ]; then
	# Installs Conda
    # Not for docker containers
	if [ -f "~/miniconda.sh" ]; then rm -fr "~/miniconda.sh"; fi
	echo "Installing Conda..."
  	wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh
    /bin/bash ~/miniconda.sh -b -p $HOME/miniconda3
    rm -fr "~/miniconda.sh"
	export PATH=$PATH:$HOME/miniconda3/bin

elif [ -d "$HOME/miniconda3" ]; then
	echo "Conda Installation found..."
    echo "Adding conda to PATH..."
	export PATH=$PATH:$HOME/miniconda3/bin
else
	echo "Existing Conda Installation was found..."
fi

# Conda Fix
conda init bash
source ~/.bashrc

# Install in Conda
echo "Installing Conda Python Packages..."
conda install pytorch torchvision torchaudio cpuonly -c pytorch
conda env create -f environment-cpuonly.yaml
# or update
# conda env update --name sdco --file environment-cpuonly.yaml --prune
conda activate sdco

# Install Requirements
echo "Installing requirements in conda environment..."
pip install pynvml gradio keras-unet fairseq basicsr facexlib
pip install -e git+https://github.com/CompVis/taming-transformers.git@master#egg=taming-transformers
pip install -e git+https://github.com/openai/CLIP.git@main#egg=clip
pip install -e git+https://github.com/TencentARC/GFPGAN#egg=GFPGAN
pip install -e git+https://github.com/xinntao/Real-ESRGAN#egg=realesrgan
pip install -e git+https://github.com/hlky/k-diffusion-sd#egg=k_diffusion


# Copy Models
echo "Copying models..."
mv sd-v1-4.ckpt models/ldm/stable-diffusion-v1/model.ckpt
mv GFPGANv1.3.pth src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth

# Ok
echo "You can now run run_sdco.sh"