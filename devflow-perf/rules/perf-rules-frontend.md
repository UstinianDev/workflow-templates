---
name: perf-rules-frontend
description: 前端性能优化规则 F01-F10，检测到前端技术栈时由 devflow-perf 自动加载
disable-model-invocation: true
---

# 前端性能优化规则（F01-F10）

> 检测到前端时加载。适用 React/Vue/Angular/Svelte/Next.js/Nuxt。

## F01 减少不必要渲染
- **检测**：纯展示组件未做渲染优化，父更新子无条件重渲染
- **方案**：
  - React：React.memo + useMemo + useCallback
  - Vue：computed + v-once + shouldUpdate
  - Angular：OnPush ChangeDetectionStrategy + trackBy
  - Svelte：编译器自动优化
- **提升**：渲染减少 30-60% | **风险**：低

## F02 大列表优化
- **检测**：列表 >100 项，或列表项含复杂组件
- **方案**：
  - 虚拟滚动：react-window / vue-virtual-scroller / @angular/cdk/scrolling
  - 分页或无限滚动（Intersection Observer + 分批加载）
- **边界测试**：空列表、单条、快速滚动、动态增删
- **提升**：渲染减少 80-95% | **风险**：中

## F03 图片优化
- **检测**：img 无懒加载、PNG/JPG 大图、无响应式
- **方案**：loading="lazy"；WebP/AVIF+fallback；srcset+sizes；构建时压缩(imagemin)；图片CDN
- **提升**：加载减少 40-70% | **风险**：低

## F04 字体优化
- **检测**：过多字体变体、无 font-display、未预加载
- **方案**：font-display:swap；字体子集化；link rel=preload；限制变体；系统字体栈
- **提升**：FCP -200~500ms | **风险**：低

## F05 资源加载优化
- **检测**：未压缩、未 Tree Shaking、关键资源未预加载
- **方案**：Gzip/Brotli（Vite/webpack 自动）；ESM Tree Shaking；link rel=preload；defer/async；preconnect
- **提升**：首次加载减少 30-50% | **风险**：低

## F06 CSS 优化
- **检测**：选择器嵌套 >3 层、频繁重排重绘、未用 containment
- **方案**：简化选择器(BEM)；CSS变量；Critical CSS内联；contain:layout+paint；flexbox/grid；动画用 transform/opacity
- **提升**：渲染减少 10-30% | **风险**：低

## F07 搜索/输入防抖
- **检测**：输入直接触发 API 或重计算
- **方案**：debounce 300ms；AbortController 取消旧请求；结果缓存
- **提升**：API 请求减少 80% | **风险**：低

## F08 状态管理优化
- **检测**：全局状态过大，更新触发大范围重渲染
- **方案**：状态拆分；选择性订阅；派生状态(computed)；避免渲染中创建新对象
- **提升**：渲染范围减少 40-60% | **风险**：中

## F09 SSR / 流式渲染
- **检测**：SPA 首屏白屏过长、SEO 需求
- **方案**：Next.js SSR / Nuxt SSR / Angular Universal；Streaming SSR；SSG；Prerender
- **提升**：FCP 减少 50-80% | **风险**：高

## F10 i18n 性能
- **检测**：国际化项目加载全部语言包
- **方案**：按语言分割翻译文件；语言检测不阻塞渲染；翻译缓存
- **提升**：首包减少 30-60% | **风险**：低
