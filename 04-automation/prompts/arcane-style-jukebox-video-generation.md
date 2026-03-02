> Ещё касательно заставки, я бы хотел сделать заставку с музыкальным автоматов, в котором ставится виниловая пластинка текущей песни и запускается, но боюсь что это слишком сложно реализовать. Хочу в целом сделать заставку в стиле сериала аркейн, мне кажется их вайб подходит джазовому вечеру. Мне нужен промпт для экспресс теста генерации изображения начального и финального кадра в нейросети, а так же промпт для генерации на основе полученных кадров изображения. Помимо этого мне нужно чтобы ты рассказал, насколько сложно это сделать в блендере, с постобраткой в DaVinci Resove Studio, чтобы рендер в итоге получился сочным


Отличная идея! Стиль Arcane с его painted-текстурами, неоновым освещением и noir-атмосферой действительно идеально подходит для джазовой эстетики. Музыкальный автомат (jukebox) — культовый образ, который отлично впишется.

## Промпты для генерации изображений

### Промпт для статичных кадров (начальный и финальный)

**Для Midjourney/DALL-E/Stable Diffusion:**

```
Vintage jukebox in Arcane art style, painterly textures, 
neon pink and cyan lighting, jazz bar atmosphere, 
vinyl record spinning inside glass panel, 
Art Deco chrome details, moody noir lighting, 
high contrast, painted look, cinematic composition, 
dramatic shadows, warm amber glow mixing with cold neon, 
dark background with bokeh bar lights, 
vertical 9:16 aspect ratio, 
inspired by Fortiche Studio, 
concept art quality

--ar 9:16 --style raw --stylize 750
```

**Начальный кадр** (автомат выключен, пластинка не вставлена):

```
empty vintage jukebox, dark and moody, 
Arcane art style, painterly textures, 
waiting state, dim ambient lighting, 
chrome Art Deco details reflecting faint bar lights, 
noir atmosphere, vertical composition 9:16, 
jazz club interior background blurred, 
cool color palette with hints of warm gold
```

**Финальный кадр** (пластинка вращается, автомат светится):

```
vintage jukebox playing vinyl record, 
Arcane art style, glowing neon pink and cyan lights, 
vinyl spinning visible through glass, 
dynamic lighting, energy and motion, 
painterly texture, dramatic rim lighting, 
warm golden glow from tubes mixing with cold neon, 
jazz bar bokeh background, vertical 9:16, 
high contrast noir cinematography
```

### Промпт для image-to-video генерации

**Для Runway Gen-3/Pika/Kling AI:**

```
Camera: Slow push-in shot, slight upward tilt
Motion: Vinyl record drops into slot, mechanism activates, 
lights illuminate progressively from bottom to top, 
vinyl begins spinning, neon tubes flicker to life
Style: Maintain Arcane painted aesthetic throughout, 
preserve painterly brush strokes, no photorealistic smoothing
Lighting: Gradual warm-to-neon color transition, 
ambient occlusion preserved, rim lights intensify
Duration: 8-10 seconds
Atmosphere: Smoky jazz club, subtle depth of field shift
```

**Специфичные параметры для разных платформ:**

- **Runway Gen-3**: используйте Motion Brush для контроля вращения винила и движения света
- **Pika 1.5**: добавьте параметр `--motion 3` для умеренного движения, `--camera zoom 1.05` для лёгкого приближения
- **Kling AI**: используйте режим "Professional" с настройкой "Creativity: 0.6" (баланс между стабильностью и динамикой)