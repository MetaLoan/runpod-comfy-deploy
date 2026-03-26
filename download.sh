#!/bin/bash
# Script to download Qwen Image Edit models for ComfyUI
# Uses wget to avoid Python/pip environment issues

# Dynamically find ComfyUI installation path
COMFY_DIR=""
echo "Locating ComfyUI installation..."

# Check common RunPod locations first
for path in "/workspace/ComfyUI" "/opt/ComfyUI" "/root/ComfyUI" "/home/workspace/ComfyUI" "/home/runner/ComfyUI"; do
    if [ -d "$path" ]; then
        COMFY_DIR="$path"
        break
    fi
done

# If not found in common locations, perform a system-wide search
if [ -z "$COMFY_DIR" ]; then
    COMFY_DIR=$(find / -maxdepth 5 -type d -name "ComfyUI" -print -quit 2>/dev/null)
fi

if [ -z "$COMFY_DIR" ]; then
    echo "Error: Could not find ComfyUI directory on this machine."
    exit 1
fi

echo "Found ComfyUI at: $COMFY_DIR"
MODELS_DIR="$COMFY_DIR/models"
DIFFUSION_DIR="$MODELS_DIR/diffusion_models"
LORA_DIR="$MODELS_DIR/loras"
VAE_DIR="$MODELS_DIR/vae"
TEXT_ENCODER_DIR="$MODELS_DIR/text_encoders"

mkdir -p "$DIFFUSION_DIR"
mkdir -p "$LORA_DIR"
mkdir -p "$VAE_DIR"
mkdir -p "$TEXT_ENCODER_DIR"

echo "Downloading qwen_image_edit_2509_fp8_e4m3fn.safetensors..."
wget -q --show-progress -c -O "$DIFFUSION_DIR/qwen_image_edit_2509_fp8_e4m3fn.safetensors" "https://huggingface.co/aidiffuser/Qwen-Image-Edit-2509/resolve/main/qwen_image_edit_2509_fp8_e4m3fn.safetensors"

echo "Downloading Qwen-Image-Lightning-4steps-V1.0.safetensors..."
wget -q --show-progress -c -O "$LORA_DIR/Qwen-Image-Lightning-4steps-V1.0.safetensors" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors"

echo "Downloading qwen_image_vae.safetensors..."
wget -q --show-progress -c -O "$VAE_DIR/qwen_image_vae.safetensors" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"

echo "Downloading qwen_2.5_vl_7b_fp8_scaled.safetensors..."
wget -q --show-progress -c -O "$TEXT_ENCODER_DIR/qwen_2.5_vl_7b_fp8_scaled.safetensors" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"

echo "All models downloaded successfully!"
