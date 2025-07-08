#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
音訊轉錄與整理腳本
使用 Whisper 轉錄音訊，再用 Ollama 整理成 Markdown 格式的 Blog 文章
"""

import os
import subprocess
import json
import requests
from pathlib import Path
import argparse
from datetime import datetime

# ==================== 設定區域 ====================
# 可以在此處修改預設設定
DEFAULT_CONFIG = {
    "whisper_model": "small",  # whisper 模型：tiny, base, small, medium, large
    "ollama_model": "gemma3:4b",  # Ollama 模型名稱，可方便更改
    "ollama_host": "http://localhost:11434",  # Ollama 服務地址
    "input_folder": "./audio_input",  # 音訊檔案輸入資料夾
    "transcript_folder": "./transcripts",  # 轉錄文字檔輸出資料夾
    "output_folder": "./organized",  # 最終整理後的 Markdown 檔案輸出資料夾
    "supported_formats": [".mp3", ".wav", ".m4a", ".flac", ".aac", ".ogg", ".wma"]  # 支援的音訊格式
}

# Ollama 整理文字的 Prompt 模板
OLLAMA_PROMPT = """請將以下轉錄的中文內容整理成一篇完整的繁體中文 Blog 文章，格式要求如下：

1. 使用 Markdown 格式
2. 包含適當的標題（# 主標題）和副標題（## 副標題）
3. 內容要條理清晰，段落分明
4. 保持原意但優化表達方式
5. 移除口語化的贅字（如：那個、嗯、呃等）
6. 確保使用繁體中文
7. 如果內容適合，可以加入適當的列表或重點整理

轉錄內容：
{transcript}

請開始整理："""

class AudioTranscriptionProcessor:
    def __init__(self, config=None):
        self.config = config or DEFAULT_CONFIG
        self.setup_directories()
    
    def setup_directories(self):
        """建立必要的資料夾"""
        for folder in [self.config["input_folder"], 
                      self.config["transcript_folder"], 
                      self.config["output_folder"]]:
            Path(folder).mkdir(parents=True, exist_ok=True)
            print(f"✓ 確認資料夾存在: {folder}")
    
    def get_audio_files(self):
        """取得音訊檔案列表"""
        audio_files = []
        input_path = Path(self.config["input_folder"])
        
        for file_path in input_path.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in self.config["supported_formats"]:
                audio_files.append(file_path)
        
        return sorted(audio_files)
    
    def transcribe_audio(self, audio_file):
        """使用 Whisper 轉錄音訊檔案"""
        print(f"🎵 正在轉錄: {audio_file.name}")
        
        # 輸出檔案路徑
        output_name = audio_file.stem + ".txt"
        output_path = Path(self.config["transcript_folder"]) / output_name
        
        # 如果已存在轉錄檔案，詢問是否跳過
        if output_path.exists():
            print(f"⚠️  轉錄檔案已存在: {output_path}")
            return output_path
        
        try:
            # 執行 Whisper 轉錄
            cmd = [
                "whisper",
                str(audio_file),
                "--model", self.config["whisper_model"],
                "--language", "zh",
                "--output_dir", self.config["transcript_folder"],
                "--output_format", "txt"
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
            
            if result.returncode == 0:
                print(f"✓ 轉錄完成: {output_path}")
                return output_path
            else:
                print(f"❌ 轉錄失敗: {result.stderr}")
                return None
                
        except FileNotFoundError:
            print("❌ 找不到 Whisper 指令，請確認已安裝 OpenAI Whisper")
            print("安裝方法: pip install openai-whisper")
            return None
    
    def read_transcript(self, transcript_path):
        """讀取轉錄文字檔案"""
        try:
            with open(transcript_path, 'r', encoding='utf-8') as f:
                return f.read().strip()
        except Exception as e:
            print(f"❌ 讀取轉錄檔案失敗: {e}")
            return None
    
    def process_with_ollama(self, transcript_text, original_filename):
        """使用 Ollama 整理轉錄文字"""
        print(f"🤖 正在使用 Ollama 整理文字...")
        
        # 準備請求資料
        prompt = OLLAMA_PROMPT.format(transcript=transcript_text)
        
        data = {
            "model": self.config["ollama_model"],
            "prompt": prompt,
            "stream": False
        }
        
        try:
            response = requests.post(
                f"{self.config['ollama_host']}/api/generate",
                json=data,
                timeout=300  # 5分鐘超時
            )
            
            if response.status_code == 200:
                result = response.json()
                return result.get("response", "")
            else:
                print(f"❌ Ollama 請求失敗: {response.status_code}")
                return None
                
        except requests.exceptions.ConnectionError:
            print("❌ 無法連接到 Ollama 服務，請確認 Ollama 已啟動")
            print("啟動方法: ollama serve")
            return None
        except Exception as e:
            print(f"❌ Ollama 處理失敗: {e}")
            return None
    
    def save_blog_post(self, content, original_filename):
        """儲存整理後的 Blog 文章"""
        # 生成輸出檔案名稱
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_name = f"{original_filename}_{timestamp}.md"
        output_path = Path(self.config["output_folder"]) / output_name
        
        try:
            with open(output_path, 'w', encoding='utf-8') as f:
                # 加入一些 metadata
                f.write(f"---\n")
                f.write(f"title: {original_filename}\n")
                f.write(f"date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
                f.write(f"source: {original_filename}\n")
                f.write(f"---\n\n")
                f.write(content)
            
            print(f"✓ Blog 文章已儲存: {output_path}")
            return output_path
            
        except Exception as e:
            print(f"❌ 儲存 Blog 文章失敗: {e}")
            return None
    
    def process_all_files(self):
        """處理所有音訊檔案"""
        audio_files = self.get_audio_files()
        
        if not audio_files:
            print("❌ 在輸入資料夾中找不到支援的音訊檔案")
            return
        
        print(f"📁 找到 {len(audio_files)} 個音訊檔案")
        
        for audio_file in audio_files:
            print(f"\n{'='*50}")
            print(f"處理檔案: {audio_file.name}")
            print(f"{'='*50}")
            
            # 步驟 1: 轉錄音訊
            transcript_path = self.transcribe_audio(audio_file)
            if not transcript_path:
                continue
            
            # 步驟 2: 讀取轉錄文字
            transcript_text = self.read_transcript(transcript_path)
            if not transcript_text:
                continue
            
            # 步驟 3: 使用 Ollama 整理
            blog_content = self.process_with_ollama(transcript_text, audio_file.stem)
            if not blog_content:
                continue
            
            # 步驟 4: 儲存 Blog 文章
            self.save_blog_post(blog_content, audio_file.stem)
        
        print(f"\n🎉 所有檔案處理完成！")
        print(f"📂 轉錄檔案位於: {self.config['transcript_folder']}")
        print(f"📝 Blog 文章位於: {self.config['output_folder']}")

def main():
    parser = argparse.ArgumentParser(description="音訊轉錄與整理腳本")
    parser.add_argument("--input", "-i", help="音訊檔案輸入資料夾")
    parser.add_argument("--transcripts", "-t", help="轉錄文字檔輸出資料夾")
    parser.add_argument("--output", "-o", help="Blog 文章輸出資料夾")
    parser.add_argument("--whisper-model", "-w", help="Whisper 模型 (tiny/base/small/medium/large)")
    parser.add_argument("--ollama-model", "-m", help="Ollama 模型名稱")
    parser.add_argument("--ollama-host", help="Ollama 服務地址")
    
    args = parser.parse_args()
    
    # 更新設定
    config = DEFAULT_CONFIG.copy()
    if args.input:
        config["input_folder"] = args.input
    if args.transcripts:
        config["transcript_folder"] = args.transcripts
    if args.output:
        config["output_folder"] = args.output
    if args.whisper_model:
        config["whisper_model"] = args.whisper_model
    if args.ollama_model:
        config["ollama_model"] = args.ollama_model
    if args.ollama_host:
        config["ollama_host"] = args.ollama_host
    
    print("🚀 音訊轉錄與整理腳本啟動")
    print(f"📋 當前設定:")
    print(f"   輸入資料夾: {config['input_folder']}")
    print(f"   轉錄資料夾: {config['transcript_folder']}")
    print(f"   輸出資料夾: {config['output_folder']}")
    print(f"   Whisper 模型: {config['whisper_model']}")
    print(f"   Ollama 模型: {config['ollama_model']}")
    print(f"   Ollama 服務: {config['ollama_host']}")
    
    # 開始處理
    processor = AudioTranscriptionProcessor(config)
    processor.process_all_files()

if __name__ == "__main__":
    main()
