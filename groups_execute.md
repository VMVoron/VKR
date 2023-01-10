```python
import vk
import sqlite3
import requests
import pandas as pd
```


```python
access_token = '' #https://vkhost.github.io/ VK Admin
```


```python
my_file = open("base.db", "w+")
conn = sqlite3.connect(r'base.db')
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS groups (ID INT, name text,screen_name text, is_closed int, type text,
           deactivated text,description text,country text,city text,contacts, members INT)''')
conn.commit()

```


```python
api = vk.API(access_token = access_token)
c = ['grazhdanesb', 'mayaksbor', 'stv24', 'bor_sos', 'sbor_a5', 'publiksosnovy_bor', '47lenoblast', 'black.sbor', 'sosnovy_bor', 'publiksosnovy_bor', 'sluh.sbor', 'sbor_lookforyou', 'eco_sbor', 'kotopes_sbor', 'meriasosnovybor', 'sbornardep'] #здесь передаются названия сообществ
s = ', '.join(c)
print(s)
```

    grazhdanesb, mayaksbor, stv24, bor_sos, sbor_a5, publiksosnovy_bor, 47lenoblast, black.sbor, sosnovy_bor, publiksosnovy_bor, sluh.sbor, sbor_lookforyou, eco_sbor, kotopes_sbor, meriasosnovybor, sbornardep
    


```python
# здесь находится тело VK Script
code = """var req_params = {
"group_ids": " """ + s + """ ",
"group_id": "",
 "v": 5.131,
"fields" : "deactivated, description, members_count, country, city, contacts"
    };
var groups = API.groups.getById(req_params);
return groups;
"""
print(code)
```

    var req_params = {
    "group_ids": " grazhdanesb, mayaksbor, stv24, bor_sos, sbor_a5, publiksosnovy_bor, 47lenoblast, black.sbor, sosnovy_bor, publiksosnovy_bor, sluh.sbor, sbor_lookforyou, eco_sbor, kotopes_sbor, meriasosnovybor, sbornardep ",
    "group_id": "",
     "v": 5.131,
    "fields" : "deactivated, description, members_count, country, city, contacts"
        };
    var groups = API.groups.getById(req_params);
    return groups;
    
    


```python
response = requests.post(
    url="https://api.vk.com/method/execute",
        data={
            "code": code,
            "access_token": access_token,  # PUT YOUR ACCESS TOKEN HERE
            "v": "5.126"
        }
)
```


```python
import json
data = response.json()['response'] #['items']
data_norm = pd.json_normalize(data)
print(len(data_norm))
fields = ('id', 'description', 'members_count', 'name', 'screen_name', 'is_closed', 'city.id', 'city.title', 'country.id', 'country.title', 'contacts') 
```

    15
    


```python
for item in data:
        print('□', end = '')
        ID = item['id']
        name = item['name']
        screen_name = item['screen_name']
        is_closed = item['is_closed']
        tip = item['type']
        deactivated = item['deactivated'] if 'deactivated' in item.keys() else None
        desc = item['description'] if 'description' in item.keys() else None
        country = item['country']['title'] if 'country' in item.keys() else None
        city = item['city']['title'] if 'city' in item.keys() else None
        members = item['members_count'] if 'members_count' in item.keys() else None
        contacts = ''
        if 'contacts' in item.keys():
            for contact in item['contacts']:
                contacts += str(contact)
        else:
            contacts = None

        row = (ID, name, screen_name,is_closed,tip,deactivated,desc,country,city,contacts,members)
        conn.execute("INSERT INTO groups VALUES (?,?,?,?,?,?,?,?,?,?,?)", row)
        conn.commit()
conn.close()
```

    □□□□□□□□□□□□□□□


```python
from time import time, sleep, strptime, strftime, mktime, gmtime
```


```python
conn = sqlite3.connect(r'base.db')
c = conn.cursor()

c.execute('''CREATE TABLE IF NOT EXISTS posts
      (UID INTEGER,date date, owner_id INTEGER, post_id INTEGER, from_id INTEGER,text text,
         comments INTEGER, likes INTEGER, reposts INTEGER,views INTEGER)''')

c.execute('''SELECT * FROM groups''') # нам не надо никаких условий
conn.commit()
group_data = [-int(list(item)[0]) for item in c.fetchall()]
print(group_data)
```

    [-72889389, -405719, -16374902, -179856898, -210223887, -205426167, -198043436, -90197520, -220339, -61851282, -175377581, -77332468, -19934771, -40739823, -74929254]
    


```python
#time_threshold = '2022-02-24 00:00:00'
#time_threshold_epoch = int(mktime(strptime(time_threshold, '%Y-%m-%d %H:%M:%S'))) #convert to UNIX timestamp
```


```python
UID = 0
print('Количество групп:', len(group_data))
```

    Количество групп: 15
    


```python
#for i in range(len(group_data)):
```


```python
test_group = group_data[14]
ITERS = 5
COUNT = 100
```


```python
code = """var ITERS = 5;
var COUNT = 100;
var posts = [];
var req_params = {
        "owner_id" : """ + str(test_group) + """,
        "offset" : 0,
        "count"  : COUNT
};
var i = 0;
while(i < ITERS){
    req_params.offset = i*COUNT + ITERS*COUNT;
    var items = API.wall.get(req_params).items;

    if (items.length == 0) {
        return posts;
    }

    var ids = items@.id;
    var tmp = {};
    tmp.chunk_size = ids.length;
    tmp.dates = items@.date;
    tmp.owner_id = items@.owner_id;
    tmp.from_id = items@.from_id;
    tmp.ids = ids;
    tmp.text = items@.text;
    tmp.likes = items@.likes@.count;
    tmp.reposts = items@.reposts@.count;
    tmp.views = items@.views@.count;
    tmp.comments = items@.comments@.count;
    
    posts.push(tmp);

    i = i + 1;
}
return posts;
"""
```


```python
response = requests.post(
    url="https://api.vk.com/method/execute",
        data={
            "code": code,
            "access_token": access_token,  # PUT YOUR ACCESS TOKEN HERE
            "v": "5.126"
        }
)
```


```python
fields = ('dates', 'owner_id', 'ids', 'from_id', 'text', 'likes', 'reposts', 'views')
```


```python
import json
data = response.json()['response'] #['items']
data_norm = pd.json_normalize(data)
print(data_norm)
```

       chunk_size                                              dates  \
    0         100  [1627414660, 1627327143, 1627305761, 162720880...   
    1         100  [1621105249, 1621018106, 1620967518, 162081048...   
    2         100  [1613935931, 1613845200, 1613841641, 161376485...   
    3         100  [1601403491, 1601098754, 1601060204, 160096938...   
    4         100  [1591285800, 1591242916, 1591119566, 159100889...   
    
                                                owner_id  \
    0  [-74929254, -74929254, -74929254, -74929254, -...   
    1  [-74929254, -74929254, -74929254, -74929254, -...   
    2  [-74929254, -74929254, -74929254, -74929254, -...   
    3  [-74929254, -74929254, -74929254, -74929254, -...   
    4  [-74929254, -74929254, -74929254, -74929254, -...   
    
                                                 from_id  \
    0  [-74929254, -74929254, -74929254, -74929254, -...   
    1  [-74929254, -74929254, -74929254, -74929254, -...   
    2  [-74929254, -74929254, -74929254, -74929254, -...   
    3  [-74929254, -74929254, -74929254, -74929254, -...   
    4  [-74929254, -74929254, -74929254, -74929254, -...   
    
                                                     ids  \
    0  [14463, 14462, 14460, 14459, 14458, 14456, 144...   
    1  [14084, 14083, 14082, 14078, 14076, 14075, 140...   
    2  [13719, 13716, 13714, 13713, 13709, 13707, 137...   
    3  [13362, 13361, 13359, 13356, 13354, 13353, 133...   
    4  [12747, 12743, 12737, 12736, 12734, 12732, 127...   
    
                                                    text  \
    0  [Фракция внесла ходатайство и проект решения с...   
    1  [Субботник Керново - Форт "Красная горка". \n ...   
    2  [Ко дню рождения Красной Армии\n\nх/ф "Срочно....   
    3  [Текучка, Поход за грибами в район Верхних Луж...   
    4  [На 1 июля назначено голосование по поправкам ...   
    
                                                   likes  \
    0  [17, 5, 30, 12, 12, 25, 37, 1, 28, 3, 10, 17, ...   
    1  [25, 7, 8, 26, 7, 14, 24, 5, 11, 12, 5, 2, 25,...   
    2  [4, 6, 7, 15, 3, 7, 15, 9, 9, 2, 6, 8, 2, 12, ...   
    3  [5, 7, 7, 11, 21, 4, 2, 7, 41, 21, 5, 2, 6, 4,...   
    4  [16, 21, 5, 9, 11, 2, 16, 80, 4, 4, 7, 10, 11,...   
    
                                                 reposts  \
    0  [2, 1, 2, 1, 2, 2, 2, 0, 3, 0, 0, 1, 2, 2, 9, ...   
    1  [5, 0, 0, 6, 0, 1, 7, 2, 4, 3, 1, 0, 1, 7, 0, ...   
    2  [0, 1, 0, 4, 1, 0, 5, 1, 0, 0, 1, 2, 0, 5, 0, ...   
    3  [0, 0, 2, 2, 2, 0, 0, 0, 1, 1, 1, 0, 1, 0, 4, ...   
    4  [3, 2, 0, 0, 4, 0, 0, 9, 0, 0, 0, 0, 0, 1, 0, ...   
    
                                                   views  \
    0  [512, 183, 692, 250, 235, 393, 482, 127, 439, ...   
    1  [824, 220, 240, 696, 247, 259, 590, 129, 746, ...   
    2  [180, 187, 238, 388, 179, 284, 560, 330, 204, ...   
    3  [397, 484, 501, 574, 604, 258, 202, 333, 559, ...   
    4  [704, 627, 257, 225, 452, 191, 242, 4254, 246,...   
    
                                                comments  
    0  [2, 0, 2, 0, 0, 0, 5, 0, 0, 0, 0, 13, 4, 0, 1,...  
    1  [0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, 0, ...  
    2  [0, 0, 5, 0, 0, 0, 1, 10, 0, 0, 8, 3, 0, 3, 3,...  
    3  [1, 0, 0, 2, 1, 0, 0, 0, 3, 0, 0, 0, 1, 1, 6, ...  
    4  [13, 6, 0, 0, 0, 0, 0, 9, 2, 0, 0, 1, 0, 0, 0,...  
    


```python
len(data_norm)
```




    5




```python
fields = ('dates', 'owner_id', 'ids', 'from_id', 'text', 'comments', 'likes', 'reposts', 'views')
dates, owner_id, ids, from_id, text, comments, likes, reposts, views = [[] for _ in range(len(fields))]
listf = [dates, owner_id, ids, from_id, text, comments, likes, reposts, views]
```


```python
data_norm[fields[0]][4][0]
```




    1591285800




```python
for j in range(len(listf)):
    for i in range(len(data_norm)):
        for k in range(COUNT):
            listf[j].append(data_norm[fields[j]][i][k])
```


```python
len(text)
```




    500




```python
for f in listf:
    if any(x == '' for x in f):
        print('Empty lines found')
```

    Empty lines found
    


```python
len(listf[0])
```




    500




```python
text = [[] for _ in range(COUNT*ITERS)]
text_norm = [[] for _ in range(ITERS)]
start = 0; stop = COUNT;
for q in range(ITERS):
    text_norm[q] = str(data_norm['text'][q]).split("', ")
```


```python
ITERS*COUNT
```




    500




```python
k = 0
while k < ITERS*COUNT:
    for i in range(5):
        for j in range(100):
            text[k] = text_norm[i][j]
            t = text_norm[i][j]
            t = str(t).replace("\\n", " ")
            t = t.replace('\\', '')
            t = t.replace('\'', '')
            text[k] = t
            k += 1
```


```python
text[5]
```




    'Сегодня в бухте Батарейная прошел субботник, организованный сообществом [club196212372|Батарейная для людей] при участии актива Сосновоборского городского отделения КПРФ: Николая Кузьмина, Ивана Апостолевского и Виталия Лопухина. Добровольцами - защитниками Бухты собраны десятки мешков с мусором.  #КПРФ #СосновыйБор #БухтаБатарейная'



```python
COUNT*ITERS
```




    500




```python
len(text)
```




    500




```python
UID = 0
for post in range(len(listf[0])):
    row = (UID,
           strftime("%Y-%m-%d %H:%M:%S", gmtime(dates[UID])),
           owner_id[UID],
           ids[UID],
           from_id[UID],
           text[UID],
           comments[UID],
           likes[UID],
           reposts[UID],
           views[UID])
    UID += 1
    conn.execute("INSERT INTO posts VALUES (?,?,?,?,?,?,?,?,?,?)", row)
    conn.commit()              
```


```python
conn.close()
```


```python
#offset += 100    
#if json_form['items'][-1]['date'] < time_threshold_epoch: # тоже убрать коммент
            #print('threshold is reached')
```
