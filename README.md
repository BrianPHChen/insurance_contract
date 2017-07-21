# insurance_contract

建構子的參數各輸入 受益人地址, 戶政事務所地址以及每期應付金額

接下來利用外部API讓保險公司跟戶政事務所要簽名
以判斷受益人還活著為例，並用web3來做線下簽名

```
sha3msg = web3.sha3("true")
sig = eth.sign(user, sha3msg)

r = sig.slice(0,66)
s = '0x' + sig.slice(66,130)
v = '0x' + sig.slice(130,132)
v = web3.toDecimal(v)
```

取得r, s, v後呼叫合約function payment()
true的話，支付每期應付款項給受益人
false的話，把合約中剩下所有的錢交還給保險公司
