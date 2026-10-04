---
name: perf-rules-core
description: 通用性能优化规则 G01-G10，前端后端均适用，由 devflow-perf 自动加载
disable-model-invocation: true
---

# 通用性能优化规则（G01-G10）

> 所有技术栈适用。检测条件 + 方案 + 预期提升 + 风险。

## G01 防抖与节流
- **检测**：高频事件（scroll/resize/keypress）直接触发重操作
- **方案**：防抖用于输入/搜索；节流用于滚动/拖拽
- **提升**：事件触发减少 80-95% | **风险**：低

## G02 内存泄漏
- **检测**：未清理的定时器、事件监听器、订阅、WebSocket
- **方案**：配对清理（useEffect cleanup、removeEventListener、clearInterval、close、unsubscribe）
- **风险**：中

## G03 重排重绘
- **检测**：频繁交替读写 DOM 属性（offsetHeight/getBoundingClientRect）
- **方案**：读写分离，批量修改 DOM，用 rAF 合并动画帧
- **提升**：渲染减少 30-60% | **风险**：低

## G04 Web Worker / 多线程
- **检测**：主线程 >100ms 同步计算任务
- **方案**：JS→Web Worker；Python→multiprocessing；Java→线程池；Go→goroutines
- **提升**：主线程阻塞减少 90%+ | **风险**：中

## G05 并行请求
- **检测**：连续 await 无数据依赖
- **方案**：JS→Promise.all/allSettled；Python→asyncio.gather；Java→CompletableFuture.allOf；Go→goroutines+WaitGroup
- **注意**：Promise.all 一个失败全失败，评估是否用 allSettled
- **提升**：等待减少 50-70% | **风险**：低

## G06 缓存策略
- **检测**：相同数据重复查询，无缓存
- **方案**：内存缓存(Map/LRU) → Redis → HTTP Cache-Control → CDN → Service Worker
- **注意**：缓存一致性需额外处理（TTL/失效/版本）
- **提升**：响应提升 80-95% | **风险**：中

## G07 批量操作
- **检测**：循环内逐条执行数据库/网络/文件操作
- **方案**：批量 INSERT/UPDATE/DELETE，合并请求
- **提升**：操作减少 70-90% | **风险**：低

## G08 懒加载
- **检测**：首屏加载非必要资源
- **方案**：图片→loading="lazy"；组件→动态import；数据→滚动到底再请求
- **提升**：首屏减少 30-60% | **风险**：低

## G09 性能监控
- **检测**：缺少性能基准数据
- **方案**：建立基线，Performance API/console.time，生产 RUM，CI/CD 性能预算
- **风险**：低

## G10 代码分割
- **检测**：单 bundle >200KB 或首屏加载非首屏代码
- **方案**：路由级→lazy loading；组件级→动态import；第三方→单独chunk
- **提升**：首屏减少 40-60% | **风险**：低
