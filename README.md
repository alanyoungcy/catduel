# 貓咪二段式剪刀石頭布 🐱

一款可愛的貓咪主題剪刀石頭布遊戲，採用獨特的二段式玩法！使用 Godot 4 開發，支援繁體中文，可以雙人本機對戰或挑戰 AI。

## 🎮 遊戲特色

**二段式玩法：**
- 第一階段：秘密選擇兩個手勢（可重複）
- 第二階段：秘密刪除一個，保留最終手勢
- 最後同時公開，增加心理博弈的樂趣！

**遊戲模式：**
- 🎲 雙人本機對戰 - 與朋友面對面較量
- 🤖 挑戰電腦 - 與 AI 貓咪「阿灰」對戰

**賽制選擇：**
- 單局定勝負
- 三盤兩勝
- 先淨勝 2 局

## 🌟 角色介紹

- **橘子** - 活潑的橘色小貓
- **阿灰** - 聰明的灰色小貓

## 🎯 線上試玩

[點此遊玩](https://catduel.vercel.app)

## 🛠️ 技術細節

- **引擎**: Godot 4.6
- **語言**: GDScript
- **渲染**: GL Compatibility
- **字體**: Noto Sans TC
- **部署**: Vercel (Web Export)

## 🖼️ 遊戲截圖

### 主選單
![主選單](docs/screenshot-menu.png)

### 遊戲畫面
![遊戲畫面](docs/screenshot-gameplay.png)

## 🚀 本地開發

### 需求
- Godot 4.6+ (標準版，非 Mono 版)

### 執行
1. 用 Godot 打開專案
2. 按 F5 執行

### Web 匯出
```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --export-release "Web" dist/catduel.html
```

## 📦 專案結構

```
├── assets/               # 遊戲素材
│   ├── characters/      # 角色圖片
│   ├── animations/      # 動畫幀
│   ├── backgrounds/     # 背景圖
│   └── fonts/          # 字體檔案
├── scenes/              # Godot 場景
├── scripts/             # GDScript 腳本
│   ├── main.gd         # 主遊戲邏輯
│   ├── game_state.gd   # 遊戲狀態管理
│   └── ai_opponent.gd  # AI 對手邏輯
└── dist/               # Web 匯出目錄
```

## 🎨 素材列表

| 名稱 | 描述 | 尺寸 | 路徑 |
|---|---|---:|---|
| 橘子 | 橘色貓角色 | 300×300 | `assets/characters/juzi.png` |
| 阿灰 | 灰色貓角色 | 300×300 | `assets/characters/ahui.png` |
| 對戰場景 | 主戰場背景 | 1280×720 | `assets/backgrounds/battle_arena.png` |
| 橘子待機 | 橘子的原始待機角色 | 220×220 | `assets/characters/juzi.png` |
| 橘子前搖 | 橘子的準備姿勢 | 220×220 | `assets/animations/juzi/frames/windup.png` |
| 橘子石頭 | 橘子的握拳貓爪 | 200×150 | `assets/animations/juzi/frames/rock.png` |
| 橘子剪刀 | 橘子的 V 字貓爪 | 200×150 | `assets/animations/juzi/frames/scissors.png` |
| 橘子布 | 橘子的張開貓掌 | 200×150 | `assets/animations/juzi/frames/paper.png` |
| 橘子勝利 | 橘子的歡呼姿勢 | 220×220 | `assets/animations/juzi/frames/victory.png` |
| 橘子落敗 | 橘子的沮喪姿勢 | 220×220 | `assets/animations/juzi/frames/defeat.png` |
| 阿灰待機 | 阿灰的原始待機角色 | 220×220 | `assets/characters/ahui.png` |
| 阿灰前搖 | 阿灰的準備姿勢 | 220×220 | `assets/animations/ahui/frames/windup.png` |
| 阿灰石頭 | 阿灰的握拳貓爪 | 200×150 | `assets/animations/ahui/frames/rock.png` |
| 阿灰剪刀 | 阿灰的 V 字貓爪 | 200×150 | `assets/animations/ahui/frames/scissors.png` |
| 阿灰布 | 阿灰的張開貓掌 | 200×150 | `assets/animations/ahui/frames/paper.png` |
| 阿灰勝利 | 阿灰的歡呼姿勢 | 220×220 | `assets/animations/ahui/frames/victory.png` |
| 阿灰落敗 | 阿灰的沮喪姿勢 | 220×220 | `assets/animations/ahui/frames/defeat.png` |

## 📝 授權

此專案僅供學習與展示用途。

## 🐛 已知問題

- Web 版本需要支援 SharedArrayBuffer 的瀏覽器（需 Cross-Origin Isolation）

## 🎉 致謝

使用 Godot 4 引擎開發
