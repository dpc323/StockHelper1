
/***********
http://www.360doc.com/content/14/0303/22/1944636_357475863.shtml
已经实现功能
功能一：手动输入
功能二：自动获取
功能三：数字输入键盘
最大可能性价格
均值预测
目前需增加功能
黄金分割比率图表等
开收盘预测 已经很简单了
统计用户数量

用户注册 10*1 100*100 1000*1000
固定测试次数 每天5次  必须后台返回

付费模式一次性收费还是 多次查询收费

加密封装sdk
动态url请求
 
 
 接口：
 https://www.jisilu.cn/question/22502
 http://gu.qq.com/sz399005
 
 
 
 http://www.bizeway.net/read.php?317
 http://table.finance.yahoo.com/table.csv?s=600000.ss  上市数据链接
 http://table.finance.yahoo.com/table.csv?s=000001.sz  深市数据链接
 上证综指代码：000001.ss，深证成指代码：399001.SZ，沪深300代码：000300.ss
 
 股票价格波动跟比率分析
 成交量跟股票波动关系
 
 预测不精准细化
 短线惯性需修复
 
 成交量分析
 
／／ 查询历史数据
 http://bbs.csdn.net/topics/390715042/
 例子http://market.finance.sina.com.cn/pricehis.php?symbol=sh600900&startdate=2011-08-17&enddate=2011-08-19
 
 预测模型：贝叶斯预测模型
 http://baike.baidu.com/link?url=1wVYywW-NoUizr7t8UlD_YyIx8QnfzQ4-A9sDPbqZ2E3iOITwK_tv6zYiusHgwhny8GsE4quNX5rvqb9QZ11PvNB29kMlSqCXOmcnpiOEquQa01MNsoOPxiflCO6MQn0uofkLbm22Op6kePV9D_OkK
 
 常见的预测模型有一元线性回归模型，计算公式为Y=a+b*x.
 一元非线性回归模型：Y=a+bl*x1+b2*x2+…+bm*xm。
 
 经典回归模型
 https://wenku.baidu.com/view/a7f57f07a76e58fafab00323.html
 
 定性、定量预测方法
 定量：
 趋势外推预测法
 时间序列预测法
 回归预测法
 近期 短期 中期 长期
 重复 反复
 
 江恩时间法则
 
 误差值 mape = 1/n(ft -f(t-1))/ft*100%
 
 
 最小二乘法应用加举例计算误差
 https://wenku.baidu.com/view/d51d26e7e53a580216fcfe62.html （计算误差最详细了）
 
 神经网络 激活函数 （强于回归等算法拟合能力）
 BP学习算法 单点预测 连续预测
 
 DeepMind团队通过强化学习，完成了20多种游戏，实现了端到端的学习。其用到的算法就是Q Network。2015年，DeepMind团队在《Nature》上发表了一篇升级版：
 http://diyhpl.us/~nmz787/pdf/Human-level_control_through_deep_reinforcement_learning.pdf
 
 神经网络学习 http://www.36dsj.com/archives/39775
 
 sgn函数 单层  两层sigmoid函数 多层ReLU函数
 
 历史数据接口 搜狐
 使用说明：http://www.w2bc.com/article/121837
 http://blog.sina.com.cn/s/blog_7ed3ed3d0101foih.html
 http://q.stock.sohu.com/hisHq?code=cn_601766,cn_000002&start=20170401&end=20170419
 http://q.stock.sohu.com/hisHq?code=cn_000829&start=20170125&end=20170426&period=w 可查找周线数据
*************/


/*******************************************需求分析2.0**************************************/
1、重构数据下载模块，更换搜狐接口，周线系统
2、添加记分系统 （大盘上涨、涨跌股票比例分析）
3、查找相同走势，匹配n段数据
/****************************************************************************************/


/*******************************************需求分析3.0**************************************/
1、添加boll kdj macd sar等指标
3、研究深度学习 神经网络应用
/****************************************************************************************/

