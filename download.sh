#!/bin/bash
# Script to download Qwen Image Edit models for ComfyUI
# Requires huggingface_hub

pip install -U huggingface_hub

# Define standard model directories for ComfyUI
MODELS_DIR="/workspace/ComfyUI/models"
DIFFUSION_DIR="$MODELS_DIR/diffusion_models"
LORA_DIR="$MODELS_DIR/loras"
VAE_DIR="$MODELS_DIR/vae"
TEXT_ENCODER_DIR="$MODELS_DIR/text_encoders"

mkdir -p "$DIFFUSION_DIR"
mkdir -p "$LORA_DIR"
mkdir -p "$VAE_DIR"
mkdir -p "$TEXT_ENCODER_DIR"

echo "Downloading qwen_image_edit_2509_fp8_e4m3fn.safetensors..."
huggingface-cli download aidiffuser/Qwen-Image-Edit-2509 qwen_image_edit_2509_fp8_e4m3fn.safetensors --local-dir "$DIFFUSION_DIR" --local-dir-use-symlinks False

echo "Downloading Qwen-Image-Lightning-4steps-V1.0.safetensors..."
huggingface-cli download lightx2v/Qwen-Image-Lightning Qwen-Image-Lightning-4steps-V1.0.safetensors --local-dir "$LORA_DIR" --local-dir-use-symlinks False

echo "Downloading qwen_image_vae.safetensors..."
huggingface-cli download Comfy-Org/Qwen-Image_ComfyUI split_files/vae/qwen_image_vae.safetensors --local-dir "$VAE_DIR" --local-dir-use-symlinks False
if [ -f "$VAE_DIR/split_files/vae/qwen_image_vae.safetensors" ]; then
    mv -f "$VAE_DIR/split_files/vae/qwen_image_vae.safetensors" "$VAE_DIR/"
    rm -rf "$VAE_DIR/split_files"
fi

echo "Downloading qwen_2.5_vl_7b_fp8_scaled.safetensors..."
huggingface-cli download Comfy-Org/Qwen-Image_ComfyUI split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors --local-dir "$TEXT_ENCODER_DIR" --local-dir-use-symlinks False
if [ -f "$TEXT_ENCODER_DIR/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" ]; then
    mv -f "$TEXT_ENCODER_DIR/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "$TEXT_ENCODER_DIR/"
    rm -rf "$TEXT_ENCODER_DIR/split_files"
fi

echo "All models downloaded successfully!"
