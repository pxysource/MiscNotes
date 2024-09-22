# 将JSON数据写入文件

```python
import json
import os.path as path
import numpy as np

script_path = path.abspath(__file__)
script_dir = path.dirname(script_path)

x = range(1,1001)
y = np.random.randint(100,300,1000)

data = []

for i in range(0,1000):
    data.append({'x':x[i], 'y':int(y[i])})

# 将JSON数据写入文件
with open(path.join(script_dir, 'data.json'), 'w+') as f:
    json.dump(data, f)
```

