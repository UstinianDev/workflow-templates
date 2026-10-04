# 范例 · 齿轮城·晨钟（原创故事 + 权游风格片头模板的完整提示词）

> 这是 /devflow-video 的 few-shot 范例之二，专门演示**火星基地范例没覆盖的两个点**：
> 1. **画面段与音频段分列输出**——权游模板是全片级 AUDIO 段，不与单镜头画面合并（对应 SKILL.md 步骤 4"模板挂接位置"规则）。
> 2. **时间轴裁剪规则**——全片 >30s 时，模板最后一段（26–30s 收尾钟声）固定放在全片结尾，中间音频段按画面实际节拍循环占位（对应 SKILL.md 步骤 3 裁剪规则）。
>
> 注意：本范例**未做真实出片验证**，仅演示结构正确性，不代表措辞在 Pavo Agnes 或其他模型上的实测最优解。

## 需求

- 主题：机械齿轮城在黎明醒来，主发条启动，全城齿轮咬合、晨钟敲响（权游类时钟机械片头题材）
- 时长：**45 秒**，画面拆 6 段（0~8s / 8~16s / 16~24s / 24~32s / 32~40s / 40~45s）
- 目标模型：通用（未指定）
- 风格：权游类时钟机械片头 → **已加载 `templates/game-of-thrones-style.md`**
- 对齐判定：主角（齿轮城/主发条）明确、时长（45s）明确、风格明确、场景 ≤2（城外观 + 主发条机心）且已描述 → 四条门槛全满足，**已跳过 grilling**（按 SKILL.md 步骤 1 注明）

## 分镜脚本

| 段 | 时间 | 景别 | 主体 | 动作 | 场景描述 | 可选（视角/构图/运动） | 留空原因 |
|---|---|---|---|---|---|---|---|
| 1 | 0~8s | 大远景 | 齿轮城 | 黎明薄雾中城市轮廓浮现，主塔顶端发条机构缓缓亮灯 | 群山间机械城，晨雾 | 视角：low-angle shot | 留空运动：开场静止建立空间，加运动会破坏"醒来前的寂静" |
| 2 | 8~16s | 特写 | 主发条 | 发条棘爪逐格咬合，黄铜齿面反光 | 机心内部，暖金光 | 运动：rack focus（从发条前缘转到齿面） | 留空构图/视角：rack focus 已含焦点运动，再加视角会超 3 硬约束 |
| 3 | 16~24s | 中景 | 齿轮组 | 大小齿轮依次咬合转动，链条绷直 | 机心，铜锈与抛光金属 | 视角：eye-level shot | 留空运动：齿轮自身转动即为动作，另加机位运动会与咬合节奏打架 |
| 4 | 24~32s | 全景 | 城内部街道 | 机关闸门升起，蒸汽沿管道喷出 | 齿轮城街道，晨光斜射 | 运动：dolly-out | 留空构图：dolly-out 拉出即揭示空间，无需再锁构图 |
| 5 | 32~40s | 大远景 | 全城 | 全城齿轮同步转动，光带沿塔群流动 | 黎明机械城全景 | 视角：high-angle shot | 留空运动：俯视同步律动已有"苏醒"节奏，加机位运动反抢 |
| 6 | 40~45s | 中景 | 主钟 | 钟锤落下，钟口黄铜泛光，余震波纹 | 主钟下方，晨雾未散 | 视角：low-angle shot | 留空运动：结尾静止凝视，与 26–30s 钟声收尾对齐 |

### 时间轴对齐说明（全片 45s > 模板 30s，走裁剪/扩展规则）

- **模板 26–30s 收尾钟声**：固定放在全片**结尾**（40–45s 段），主钟钟锤落下与钟声收尾对齐。
- **模板中间段（0–26s）按画面节拍循环占位**：画面 45s、模板 30s，缺口 15s 用 0–26s 中间机制音循环填充，空缺段以 `silence / 环境底噪` 占位，并在下方音频段显式标注。
- **对齐判定**：每个画面分镜段都对应到至少一个音频段（音频段 1 对多，画面段不断音）；第 6 段（40–45s）对应模板收尾钟声段，无错位。

## 画面提示词（可直接粘贴）

```
第 1 段（0~8s）：大远景，齿轮城在黎明薄雾中轮廓浮现，主塔顶端发条机构缓缓亮灯，群山间机械城，low-angle shot。
第 2 段（8~16s）：特写，主发条棘爪逐格咬合，黄铜齿面反光，机心内部暖金光，rack focus。
第 3 段（16~24s）：中景，大小齿轮依次咬合转动，链条绷直，机心铜锈与抛光金属，eye-level shot。
第 4 段（24~32s）：全景，机关闸门升起，蒸汽沿管道喷出，齿轮城街道晨光斜射，dolly-out。
第 5 段（32~40s）：大远景，全城齿轮同步转动，光带沿塔群流动，黎明机械城全景，high-angle shot。
第 6 段（40~45s）：中景，钟锤落下，钟口黄铜泛光，主钟下方晨雾未散，low-angle shot。

风格：Ultra-detailed miniature craftsmanship, tactile physical realism, coherent geography,
stable rigid architecture, functional clockwork engineering, cinematic lighting,
restrained antique color grading, premium television-title production quality
```

> 风格行直接采用模板自带的画面定调词（SKILL.md 步骤 4：模板中已写清的画面定调词可单独作全片风格行，其余画面细节不重复描述）。

## 音频提示词（分列输出，仅加载模板时生成此段）

> 以下为 `game-of-thrones-style.md` 的 AUDIO 段按 45s 全片裁剪后的结果，与画面段**分列**，不做文字级合并：

```
Create a fully synchronized, purely diegetic mechanical soundscape.

- 0–8 seconds: low amber-core resonance, brass ring rotation, polished bearings, a subtle heartbeat-like wooden pulse.
- 8–16 seconds: pinions engaging, dry wind across parchment, distant gear trains beginning.
- 16–24 seconds: compact ratchets, foot locks, chain-guided tail movement, one sharp jaw click.
- 24–32 seconds: resin-water flow, hinged vegetation, heavy rack lifts, telescoping neck mechanisms, a low brass below.
- 32–40 seconds: (循环 0–16s 中间段) rushing air, distant gear trains, compact ratchets; 空缺处填 silence / 环境底噪
- 40–45 seconds: all systems synchronize and settle, followed by one long, rich bronze chime with a natural spherical echo.
```

裁剪依据：全片 45s > 模板 30s → 26–30s 收尾钟声移到全片结尾（40–45s）；中间段按画面 8s 一拍循环占位，缺口 15s 用 0–16s 段循环 + `silence / 环境底噪` 占位（已在 32–40s 显式标注）。

## 自检记录（按规则库 4.1~4.4 逐项过）

1. **具体性（4.1 抽象词黑名单）**：全文未命中"史诗感/孤独感/压抑/震撼/仪式感"等抽象词 ✅（"苏醒/醒来"是可见画面，不是抽象情绪词）
2. **非矛盾（4.2 互斥词对）**：第 2 段"特写"与"rack focus（焦点在发条前缘→齿面间移动）"不冲突（焦点转移与特写景别兼容）；第 6 段"钟锤落下（动作）+ 结尾静止凝视"——落钟动作结束于段内前 3s，后 2s 静止收束，同段分节拍、非同一时刻互斥，判定通过 ✅
3. **正面描述（4.3 否定词扫描）**：画面段未用"不要/避免"；音频段出现 "purely diegetic / 无配乐" 属**音频提示词例外**（规则库 4.3 音频段允许 negative 描述，音频模型支持 negative prompt），不在画面段违规 ✅
4. **不过度指定（4.4 阈值）**：
   - 硬约束：第 2 段 = 景别（特写）+ 运动（rack focus）= 2，≤3 ✅；其余各段均 ≤2 ✅
   - 视觉属性词（颜色/材质/方位/光效各自去重）：单段最多 4（如第 2 段 黄铜色+暖金光+前缘+齿面），≤6 ✅

## 遗留风险

- **全片 45s 超出方法论文档"0~3s/3~6s"短节拍惯例**：本例用 8s 长拍是为匹配时钟机械片头的缓节奏，属有意选择；若目标模型偏好短拍，建议把每段拆回 3–4s 并相应加密音频段循环次数。
- **音频循环占位是方法论推断，非实测**：32–40s 用 0–16s 段循环 + silence 占位，实际出片可能露出重复感；先出 1 次片听循环衔接，若生硬就把循环起点改为 0–8s（更短的循环单元更不易察觉）。
- **收尾钟声与画面钟锤必须同拍**：40–45s 画面"钟锤落下"须与模板 26–30s 钟声的**响钟点**对齐，若出片钟声提前/滞后，调整画面第 6 段钟锤落下的帧位置，不改音频。
- 目标模型未指定，**时间戳法/首尾帧垫图未启用**（保守文生视频写法）；若用 Pavo Agnes 支持垫图，可在每段首帧垫"齿轮城"定调帧增强一致性。
