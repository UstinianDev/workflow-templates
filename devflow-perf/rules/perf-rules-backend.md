---
name: perf-rules-backend
description: 后端性能优化规则 B01-B11，检测到后端技术栈时由 devflow-perf 自动加载
disable-model-invocation: true
---

# 后端性能优化规则（B01-B11）

> 检测到后端时加载。适用 Node/Express/Nest/Django/Flask/Spring/Go。

## B01 避免 N+1 查询
- **检测**：循环内有数据库查询（for/forEach 内 await 查询）
- **方案**：
  - Prisma：include 或 findMany + select
  - Sequelize/TypeORM：include / relations + joinLeftAndSelect
  - Django：select_related / prefetch_related
  - SQLAlchemy：joinedload / subqueryload
  - MyBatis：`<collection>` 或批量查询
  - ActiveRecord：includes / eager_load
- **边界测试**：空关联、深层嵌套、大量关联数据
- **提升**：10x+ | **风险**：中

## B02 索引优化
- **检测**：WHERE/JOIN/ORDER BY/GROUP BY 字段无索引
- **方案**：EXPLAIN ANALYZE 分析慢查询；添加索引；复合索引按选择度排序；覆盖索引
- **注意**：索引影响写入性能
- **提升**：50-90% | **风险**：低

## B03 精确查询
- **检测**：SELECT * 或 ORM find() 未指定字段
- **方案**：
  - SQL：SELECT field1, field2
  - Prisma：select: { field1: true }
  - TypeORM：QueryBuilder.select(['field1'])
  - Django：.values('field1')
  - GraphQL：客户端指定字段
- **提升**：传输减少 30-70% | **风险**：低

## B04 连接池优化
- **检测**：每次请求新建连接或连接池配置不当
- **方案**：启用连接池；调整 pool_min/pool_max；连接超时+空闲回收；读写分离
- **提升**：连接建立减少 90%+ | **风险**：中

## B05 异步处理
- **检测**：请求中有 >500ms 耗时操作同步阻塞
- **方案**：
  - 消息队列：RabbitMQ/Kafka/Redis Queue/Bull/Celery
  - 后台任务：Spring Async/goroutines
  - Webhook 回调或轮询
- **边界测试**：任务失败重试、超时、部分完成
- **提升**：感知响应减少 90%+ | **风险**：中

## B06 分页返回
- **检测**：列表查询未分页，一次性返回 >100 条
- **方案**：偏移分页(?page=&limit=)；游标分页(?cursor=&limit=)；流式(SSE/WebSocket)
- **提升**：响应减少 70-90% | **风险**：低

## B07 API 设计优化
- **检测**：客户端需多次请求获取完整数据，或返回冗余数据
- **方案**：聚合接口；批量接口(?ids=1,2,3)；字段选择(?fields=)；嵌套资源(?include=)；GraphQL；BFF
- **提升**：请求数减少 50-80% | **风险**：中

## B08 序列化与压缩
- **检测**：响应体 >100KB 或低效序列化格式
- **方案**：Gzip/Brotli；精简JSON(移除null/key缩短)；MessagePack/Protobuf(高性能场景)
- **提升**：传输减少 50-80% | **风险**：低

## B09 中间件优化
- **检测**：中间件过多或有阻塞操作
- **方案**：移除不必要中间件；轻量中间件前置；重中间件异步化；避免中间件重复查库
- **提升**：处理减少 20-40% | **风险**：低

## B10 日志优化
- **检测**：同步日志阻塞请求或日志级别过高
- **方案**：异步日志；生产 warn/error；结构化JSON；APM(Sentry/New Relic/Datadog)
- **提升**：处理减少 5-15% | **风险**：低

## B11 限流与熔断
- **检测**：无限流或无熔断保护
- **方案**：限流(令牌桶/滑动窗口)；熔断(Circuit Breaker: opossum/resilience4j)；降级(缓存/默认值)；超时
- **风险**：中
