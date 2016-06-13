# ZJHNetwork

封装afn，抽出专门处理网络回调的逻辑层，回调直接返回模型，避免使用字典，仅供学习

---
主要为如下四个类
#### ZJHBaseRequest
面向使用者的请求类  

* 封装 request response 的基本配置信息
* 提供成功失败等的回调，代理

#### ZJHNetworkManager
处理请求回来的网络数据的逻辑，与业务有关

* 监听网络请求发起，结束状态
* 将网络返回的json数据直接转为模型
* 处理网络错误，封装成error模型
* 网络请求成功与失败的统一处理入口

#### ZJHHttpConnection
解析ZJHBaseRequest类，发起网络请求，返回afn的成功失败数据，与业务无关

#### ZJHNetworkConfig
统一配置基本的网络请求信息