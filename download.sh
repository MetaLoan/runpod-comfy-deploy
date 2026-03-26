#!/bin/bash
# Script to download Qwen Image Edit models for ComfyUI
# Requires huggingface_hub

# Ensure pip is available
if command -v pip3 &> /dev/null; then
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    PIP_CMD="pip"
else
    PIP_CMD="python3 -m pip"
fi

echo "Installing huggingface_hub..."
$PIP_CMD install -U huggingface_hub

# Determine huggingface command
if command -v huggingface-cli &> /dev/null; then
    HF_CMD="huggingface-cli"
else
    # Fallback to python module execution if not directly in PATH
    HF_CMD="python3 -m huggingface_hub.cli"
fi

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
$HF_CMD download aidiffuser/Qwen-Image-Edit-2509 qwen_image_edit_2509_fp8_e4m3fn.safetensors --local-dir "$DIFFUSION_DIR" --local-dir-use-symlinks False

echo "Downloading Qwen-Image-Lightning-4steps-V1.0.safetensors..."
$HF_CMD download lightx2v/Qwen-Image-Lightning Qwen-Image-Lightning-4steps-V1.0.safetensors --local-dir "$LORA_DIR" --local-dir-use-symlinks False

echo "Downloading qwen_image_vae.safetensors..."
$HF_CMD download Comfy-Org/Qwen-Image_ComfyUI split_files/vae/qwen_image_vae.safetensors --local-dir "$VAE_DIR" --local-dir-use-symlinks False
if [ -f "$VAE_DIR/split_files/vae/qwen_image_vae.safetensors" ]; then
    mv -f "$VAE_DIR/split_files/vae/qwen_image_vae.safetensors" "$VAE_DIR/"
    rm -rf "$VAE_DIR/split_files"
fi

echo "Downloading qwen_2.5_vl_7b_fp8_scaled.safetensors..."
$HF_CMD download Comfy-Org/Qwen-Image_ComfyUI split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors --local-dir "$TEXT_ENCODER_DIR" --local-dir-use-symlinks False
if [ -f "$TEXT_ENCODER_DIR/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" ]; then
    mv -f "$TEXT_ENCODER_DIR/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "$TEXT_ENCODER_DIR/"
    rm -rf "$TEXT_ENCODER_DIR/split_files"
fi

echo "All models downloaded successfully!"
