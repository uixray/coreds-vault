
> Подборка промтов с маскотом и без него для мобильного приложения абсолют. Генерации изначально рассчитаны на Gemini, на по практике лучше себя проявил GPT Image Mini.
## Промпты для Gemini Pro

Сначала общая стилистическая база, которую нужно включать в каждый промпт:

> **Style base:** 3D rendered illustration, soft rounded shapes, glossy plastic/clay material, green color palette with white and warm accents, clean white background, mobile app icon style, friendly and playful aesthetic, no outlines, smooth gradients, soft shadows, high quality render, centered composition

---

### Экран 1 — Ассортимент

```
3D rendered illustration for mobile app onboarding screen. A large colorful grocery shelf overflowing with fresh products — fruits, vegetables, dairy, pastries, and packaged goods. New items are appearing on the shelf with small sparkle effects and a "NEW" tag. A small magnifying glass or search icon nearby. Soft rounded shapes, glossy plastic clay material, green color palette with white and warm accents, clean white background, friendly playful aesthetic, no outlines, smooth gradients, soft shadows, centered composition, high quality render.
```

### Экран 2 — Внимание к деталям

```
3D rendered illustration for mobile app onboarding screen. A cute green smartphone showing a 5-star review, surrounded by floating speech bubbles with heart icons, a thumbs-up emoji, and a small checklist with checkmarks. A friendly ear or headphone icon listening attentively. Soft rounded shapes, glossy plastic clay material, green color palette with white and warm accents, clean white background, friendly playful aesthetic, no outlines, smooth gradients, soft shadows, centered composition, high quality render.
```

### Экран 3 — Быстрая доставка

```
3D rendered illustration for mobile app onboarding screen. A green delivery truck speeding forward with motion lines behind it, carrying a paper bag full of fresh groceries — vegetables, bread, a milk bottle. A small clock icon showing fast time. The truck has rounded friendly design. Soft rounded shapes, glossy plastic clay material, green color palette with white and warm accents, clean white background, friendly playful aesthetic, no outlines, smooth gradients, soft shadows, centered composition, high quality render.
```

---

### Советы по генерации

- **Соотношение сторон (aspect ratio):** используй `--ar 4:5` или квадрат — так лучше ляжет в онбординг
- **Если стиль «плывёт»:** добавь `in the style of app store icon, Pixar-like 3D render, isometric view`
- **Для консистентности:** попробуй загрузить одну из референсных картинок прямо в Gemini и добавить `generate in the same visual style as the reference image`
- **Негативные подсказки:** если Gemini поддерживает — `no text, no human characters, no realistic photography`

**Что дальше:**

- Могу адаптировать промпты под другие генераторы (Midjourney, DALL-E, ComfyUI)
- Могу написать вариации с альтернативными метафорами для каждого экрана
- Могу помочь собрать онбординг-экраны в Figma с текстом и иллюстрациями

---

## Промпты для приветственных экранов

Общая стилистическая база обновлена под скриншоты:

> **Style base:** 3D rendered illustration, soft rounded glossy shapes, clay-like plastic material with subtle specular highlights, smooth gradients, no outlines, no text, centered composition, single isolated object, transparent or solid color background, mobile app splash screen style, Pixar-like friendly aesthetic, high quality render

---

### Приветственный экран (Welcome)

```
3D rendered illustration of a beige paper grocery bag filled with fresh products — a white milk bottle, a golden baguette, red tomatoes, and green vegetables sticking out from the top. The bag has a round white badge with a decorative scalloped edge on the front. Soft glossy clay-like material, rounded shapes, subtle specular highlights, warm lighting, no text, no background elements, transparent background, centered composition, high quality render.
```

### Утро (Morning)

```
3D rendered illustration of a bright yellow sun rising behind a smooth dark blue hill. The sun has a glossy spherical shape with small rounded elongated rays around it and a square specular highlight. Two small stylized white clouds with swirl details floating in the sky on both sides. Soft clay-like plastic material, light blue sky atmosphere, cheerful morning mood, no text, centered composition, transparent background, high quality render.
```

### День (Afternoon)

```
3D rendered illustration of a large bright yellow glossy sun in full view with elongated rounded rays radiating outward. The sun is a perfect sphere with a subtle square specular highlight on the surface. Warm golden glow, soft clay-like plastic material, no clouds, no other elements, warm yellow-orange atmosphere, no text, centered composition, transparent background, high quality render.
```

### Вечер (Evening)

```
3D rendered illustration of a golden yellow glossy sun partially hidden behind a cluster of soft white stylized clouds with swirl curl details. The sun has small rounded elongated rays peeking out above the clouds, with a square specular highlight. Soft clay-like plastic material, calm peaceful mood, blue sky atmosphere, no text, centered composition, transparent background, high quality render.
```

### Ночь (Night)

```
3D rendered illustration of a large glossy golden crescent moon with a small white fluffy cloud nestled at its base. Three small golden five-pointed stars floating around the moon at different heights. Soft clay-like plastic material with specular highlights, dreamy nighttime mood, purple to deep blue atmosphere, no text, centered composition, transparent background, high quality render.
```

---

### Советы по работе с этим набором

- **Прозрачный фон:** добавляй `transparent background, PNG` — фон в приложении ты и так задаёшь градиентом
- **Консистентность specular highlight:** обрати внимание, что на всех референсах на объектах есть характерный прямоугольный блик — это ключевая деталь стиля, поэтому я добавил `square specular highlight`
- **Если луна/солнце получаются слишком реалистичными:** добавь `toy-like, simplified, low-poly smooth`
- **Масштаб объекта:** если Gemini делает слишком мелко — добавь `close-up view, object fills 70% of frame`

**Что дальше:**

- Могу написать промпты для других сезонных/праздничных вариаций (Новый год, 8 марта и т.д.)
- Могу адаптировать промпты под ComfyUI/SDXL если хочешь генерить локально
- Могу помочь собрать систему экранов в Figma с автоматической подменой по времени суток

---

## Промпты с маскотом

Описание маскота для консистентности (mascot base):

> **Mascot:** A cute chubby white fluffy Samoyed puppy standing upright on hind legs, wearing a red superhero mask over eyes, a red superhero cape flowing behind, and an orange circular medal pendant with a white letter "A" on its chest. Soft fluffy white fur, big round dark eyes, small black nose, friendly smile, short rounded paws with visible pink paw pads. Semi-realistic 3D render style, white or transparent background, no text.

---

### 1. Ассортимент пополняется ежедневно

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is standing behind a large wooden grocery shelf filled with colorful fresh products — fruits, vegetables, dairy, pastries, juices, and packaged goods. The puppy is happily placing a new item on the top shelf with one paw, while the other paw holds more products. Small sparkle effects around new items. Semi-realistic 3D render, soft fluffy white fur, big dark eyes, friendly excited expression, white background, no text, centered composition, high quality render.
```

### 2. Внимательны к деталям

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is holding a clipboard with a checklist in one paw and giving a thumbs-up with the other. Floating around the puppy are small 3D icons — a green speech bubble with a heart, a golden star, a white envelope, and a magnifying glass. The puppy has a focused attentive expression with one ear slightly tilted as if listening carefully. Semi-realistic 3D render, soft fluffy white fur, big dark eyes, white background, no text, centered composition, high quality render.
```

### 3. Быстрая доставка

```
A cute chubby white fluffy Samoyed puppy running fast forward in a dynamic flying superhero pose, wearing a red superhero mask, red cape flowing dramatically in the wind behind, and orange "A" medal pendant. The puppy is holding a paper grocery bag full of fresh products — baguette, vegetables, milk bottle sticking out. Orange horizontal speed motion lines behind the puppy. Excited happy expression, paws stretched forward mid-flight. Semi-realistic 3D render, soft fluffy white fur, big dark eyes, white background, no text, centered composition, high quality render.
```

### 4. Утро (Morning)

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is stretching happily with both paws raised up as if just waking up, eyes slightly squinting with a big cheerful yawn-smile. Next to the puppy is a glossy 3D yellow sun rising behind a smooth dark blue hill with small rounded rays. Two small white stylized clouds with swirl details floating nearby. Cheerful morning mood. Semi-realistic 3D render, soft fluffy white fur, transparent background, no text, centered composition, high quality render.
```

### 5. День (Afternoon)

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is wearing small round sunglasses pushed up on its forehead above the red mask, waving one paw cheerfully at the viewer. Behind the puppy is a large bright glossy 3D yellow sun with elongated rounded rays radiating outward, warm golden glow. The puppy has an energetic happy expression. Semi-realistic 3D render, soft fluffy white fur, big dark eyes, transparent background, no text, centered composition, high quality render.
```

### 6. Вечер (Evening)

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is calmly smiling and holding a warm cup of tea or cocoa with both paws, small steam wisps rising from the cup. Behind the puppy is a glossy 3D golden yellow sun partially hidden behind soft white stylized clouds with swirl curl details. Peaceful calm evening mood. Semi-realistic 3D render, soft fluffy white fur, big dark eyes, gentle relaxed expression, transparent background, no text, centered composition, high quality render.
```

### 7. Ночь (Night)

```
A cute chubby white fluffy Samoyed puppy standing upright, wearing a red superhero mask, red cape, and orange "A" medal pendant. The puppy is sleepy and hugging a soft white pillow with both paws, eyes half-closed with a drowsy gentle smile. Behind the puppy is a large glossy golden crescent moon with a small white fluffy cloud at its base and three small golden five-pointed stars floating around. Dreamy nighttime mood. Semi-realistic 3D render, soft fluffy white fur, transparent background, no text, centered composition, high quality render.
```

---

### Рекомендации

- **Консистентность маскота:** если Gemini «забывает» детали костюма — загрузи один из референсов прямо в промпт и добавь `use this character exactly, same costume and proportions`
- **Проблема с буквой «A»:** генераторы плохо рисуют текст на объектах — скорее всего медальон придётся добавлять в Figma поверх
- **Маска:** если маска пропадает, усиль: `red leather superhero eye mask covering the area around both eyes`

**Что дальше:**

- Могу написать промпты для праздничных вариаций маскота (Новый год, Пасха, 23 февраля и т.д.)
- Могу помочь собрать гайд по маскоту (mascot guidelines) в виде документа
- Могу адаптировать под другие генераторы или под img2img в ComfyUI для лучшей консистентности