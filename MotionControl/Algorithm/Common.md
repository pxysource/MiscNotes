# 1 运动控制中的加减速算法

- 当前运动控制系统中常用的加减速算法主要有：
  - 梯形曲线加减速
  - S形曲线加减速
  - 指数曲线加减速
  - 抛物线曲线加减速等。

- 对加减速过程的评价指标主要从以下几个方面进行：
  - 采用的加减速算法能够确保足够的轨迹及位置精度，误差应该尽量的小；
  - 采用的加减速算法能使运动过程平稳、冲击和振动小，且响应迅速；
  - 采用的加减速算法应尽量简单，便于实现，计算量小，实时性强；

- 各种加减速算法的特点：
  - 梯形加减速曲线，速度阶跃时会发生失步和过冲，以指定精度到达目标位置时，容易激发残余振动；
  - 分段直线加减速曲线，过渡点处加速度有突变，电机运动存在柔性振动和冲击，且控制系统处理速度慢，适用于加速要求不高的场合；
  - 指数曲线加减速算法，具有将强的跟踪性，但起点和终点存在加速度突变，高速时稳定性弱；
  - S曲线加减速，是一种柔性程序较好的控制策略，能让电机性能得到充分的发挥，冲击振动小，但是实现过程比较复杂，计算量相对较大。