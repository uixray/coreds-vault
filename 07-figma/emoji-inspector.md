---
title: "Emoji Inspector"
type: "guide"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/guide"
  - "platform/web"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Guide or tool reference for inspecting emoji in Figma designs"
---

import json
import os

# --- НАСТРОЙКИ (TOKENS) ---
FILE_NAME = 'result.json'
OUTPUT_FILE = 'verification_output.json'

# [ВАЖНО] Впиши сюда имя пользователя ТОЧНО как в статистике
TARGET_USER_NAME = "Андрей Велжа" 

# Эмодзи, который мы ищем
TARGET_EMOJI = "😁"

def export_specific_messages():
    # 1. Загрузка (Import)
    if not os.path.exists(FILE_NAME):
        print(f"Файл {FILE_NAME} не найден.")
        return

    print(f"Ищем сообщения от '{TARGET_USER_NAME}' с эмодзи '{TARGET_EMOJI}'...")
    
    with open(FILE_NAME, 'r', encoding='utf-8') as f:
        data = json.load(f)

    found_messages = []
    
    # 2. Фильтрация (Filtering Logic)
    for message in data.get('messages', []):
        
        # Проверяем отправителя
        if message.get('from') != TARGET_USER_NAME:
            continue
            
        # Проверяем тип (только сообщения)
        if message.get('type') != 'message':
            continue

        # Собираем данные для проверки
        sticker_emoji = message.get('sticker_emoji')
        text_content = message.get('text')
        
        # [НОВОЕ] Проверяем, переслано ли сообщение
        # Telegram может писать forwarded_from (от юзера) или forwarded_from_chat (от канала)
        is_forward = False
        forward_source = None
        
        if 'forwarded_from' in message:
            is_forward = True
            forward_source = message.get('forwarded_from')
        elif 'forward_from_chat' in message:
            is_forward = True
            forward_source = message.get('forward_from_chat')

        
        full_text = ""
        # Нормализация текста (превращаем сложный объект в строку)
        if isinstance(text_content, list):
            for part in text_content:
                if isinstance(part, dict):
                     full_text += part.get('text', '')
                else:
                    full_text += str(part)
        elif isinstance(text_content, str):
            full_text = text_content

        # 3. Условия поиска (Match Conditions)
        is_match = False
        match_type = "Unknown"

        # А) Проверка: Это стикер с таким эмодзи?
        if sticker_emoji == TARGET_EMOJI:
            is_match = True
            match_type = "STICKER (Стикер)"
        
        # Б) Проверка: Этот эмодзи есть в тексте?
        elif TARGET_EMOJI in full_text:
            is_match = True
            match_type = "TEXT (Текст)"

        # 4. Сохранение (Save Snapshot)
        if is_match:
            # Создаем упрощенный объект для легкого чтения
            snapshot = {
                "id": message.get('id'),
                "date": message.get('date'),
                "type_detected": match_type, 
                
                # Блок диагностики пересылок
                "is_forward": is_forward,          # <--- СМОТРИ СЮДА
                "forward_source": forward_source,  # От кого переслано
                
                "sticker_emoji_field": sticker_emoji, 
                "text_field": text_content, 
                "clean_text": full_text 
            }
            found_messages.append(snapshot)

    # 5. Вывод (Render Output)
    print(f"Найдено сообщений: {len(found_messages)}")
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        # indent=4 делает JSON красивым и читаемым для человека
        json.dump(found_messages, f, ensure_ascii=False, indent=4)
        
    print(f"Результат сохранен в файл: {OUTPUT_FILE}")
    print("Открой его в VS Code, чтобы проверить поле 'is_forward'.")

if __name__ == "__main__":
    export_specific_messages()