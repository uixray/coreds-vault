**Промпт для Veo3:**

```
Cinematic close-up shot of white wine being poured from a green glass bottle into an elegant wine glass. The wine has a pale golden-straw color with subtle green reflections. Soft natural lighting from the side creates beautiful highlights on the glass and liquid. The pour is smooth and controlled, showing the wine gracefully flowing in an arc. Shallow depth of field with a soft teal-gray background. The glass slowly fills as wine settles with gentle movement. Premium product commercial aesthetic, 4K quality, smooth 24fps motion.
```

---

Сейчас посмотрю видео, чтобы точно описать стилистику.Видео бинарный файл, но суть понятна — нужен универсальный шаблон с переменной для цвета вина.

**Универсальный промпт-шаблон:**

```
This wine bottle from the reference image pours [WINE_COLOR] wine into an elegant crystal glass. Smooth cinematic shot, the bottle tilts gracefully as wine flows in a controlled stream. The liquid catches soft side lighting, showing its [WINE_CHARACTERISTICS]. The glass gradually fills with gentle settling motion. Soft neutral background, shallow depth of field, premium commercial aesthetic. Smooth motion, photorealistic quality.
```

**Варианты для `[WINE_COLOR]` + `[WINE_CHARACTERISTICS]`:**

|Тип вина|WINE_COLOR|WINE_CHARACTERISTICS|
|---|---|---|
|Белое|pale golden-straw|subtle green reflections and clarity|
|Красное|deep ruby-red|rich burgundy tones and legs on glass|
|Розовое|salmon-pink|delicate coral hues and transparency|
|Оранжевое|amber-orange|warm copper reflections|

**Пример для красного:**

```
This wine bottle from the reference image pours deep ruby-red wine into an elegant crystal glass. Smooth cinematic shot, the bottle tilts gracefully as wine flows in a controlled stream. The liquid catches soft side lighting, showing its rich burgundy tones and legs on glass. The glass gradually fills with gentle settling motion. Soft neutral background, shallow depth of field, premium commercial aesthetic. Smooth motion, photorealistic quality.
```

**Что дальше:**

- Могу оформить как шаблон в Obsidian с Templater
- Добавить варианты для игристых вин с пузырьками
- Сделать версию с другими ракурсами камеры